#!/usr/bin/env bash
# =============================================================================
# hermes-memory-backup.sh — Hermes Memory Backup to GitHub
#
# Backs up Hermes persistent state (memories, skills, cron jobs, kanban board,
# sessions DB, gateway state) to the user's GitHub repo.
#
# Trigger modes:
#   --now        Force a backup (user-requested / manual)
#   --test       Dry-run: verify connectivity + compute hash, no push
#   (no flag)    Automatic mode: backs up ONLY if memory content changed
#                since the last backup (watchdog mode, used by cron).
#                SILENT when there is nothing to do (empty stdout = no message
#                in a no_agent cron job); non-zero exit = error alert.
#
# Exit codes: 0 = ok (pushed or nothing to do), 1 = real failure
# =============================================================================
set -u

HERMES_HOME="${HERMES_HOME:-REDACTED}"
WORK_DIR="${WORK_DIR:-/tmp/hermes-backup}"
REPO_URL="${REPO_URL:-https://github.com/OWNER/REPO.git}"   # <-- adapt
REPO_DIR="${WORK_DIR}/repo"
STAMP_FILE="${WORK_DIR}/last_content_hash"
BRANCH="main"

MODE="${1:-auto}"
FORCE=0
TEST=0
case "${MODE}" in
  --now)  FORCE=1 ;;
  --test) TEST=1 ;;
  auto)   ;;
  *)      echo "Usage: $0 [--now|--test]"; exit 2 ;;
esac

log()  { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }
die()  { log "ERROR: $*"; exit 1; }

# --- token extraction (handles optional quotes / CRLF) ----------------------
extract_token() {
  local f="$1" line tok
  line=$(grep -m1 '^GITHUB_TOKEN=' "$f" 2>/dev/null) || return 1
  tok="${line#*=}"
  tok="${tok%$'\r'}"
  tok="${tok#\"}"; tok="${tok%\"}"
  printf '%s' "$tok"
}

TOKEN="${GITHUB_TOKEN:-}"
if [ -z "${TOKEN}" ] && [ -f "${HERMES_HOME}/.env" ]; then
  TOKEN=$(extract_token "${HERMES_HOME}/.env")
fi
if [ -z "${TOKEN}" ] && [ -f "${HERMES_HOME}/.github_token" ]; then
  TOKEN=$(extract_token "${HERMES_HOME}/.github_token")
fi
[ -n "${TOKEN}" ] || die "GITHUB_TOKEN not found (set env or add to ${HERMES_HOME}/.env)"

# --- collect the state that defines "Hermes memory" -------------------------
collect() {
  local dest="${1}"
  mkdir -p "${dest}/memories" "${dest}/skills" "${dest}/cron" "${dest}/sessions" "${dest}/state" "${dest}/kanban"
  [ -d "${HERMES_HOME}/memories" ]            && cp -a "${HERMES_HOME}/memories"/.      "${dest}/memories/" 2>/dev/null
  [ -d "${HERMES_HOME}/skills" ]              && cp -a "${HERMES_HOME}/skills"/.        "${dest}/skills/" 2>/dev/null
  [ -d "${HERMES_HOME}/cron" ]                && cp -a "${HERMES_HOME}/cron"/.          "${dest}/cron/" 2>/dev/null
  [ -d "${HERMES_HOME}/kanban" ]              && cp -a "${HERMES_HOME}/kanban"/.        "${dest}/kanban/" 2>/dev/null
  [ -f "${HERMES_HOME}/state.db" ]            && cp -a "${HERMES_HOME}/state.db"        "${dest}/sessions/state.db"
  [ -f "${HERMES_HOME}/sessions/sessions.json" ] && cp -a "${HERMES_HOME}/sessions/sessions.json" "${dest}/sessions/sessions.json"
  # gateway + channel state (no secrets: .env / auth.json deliberately excluded)
  [ -f "${HERMES_HOME}/gateway_state.json" ]  && cp -a "${HERMES_HOME}/gateway_state.json" "${dest}/state/"
  [ -f "${HERMES_HOME}/channel_directory.json" ] && cp -a "${HERMES_HOME}/channel_directory.json" "${dest}/state/"
  [ -f "${HERMES_HOME}/config.yaml" ]         && cp -a "${HERMES_HOME}/config.yaml"     "${dest}/state/config.yaml"
}

snapshot_hash() {
  ( cd "${1}" && find . -type f -print0 | sort -z | xargs -0 sha256sum 2>/dev/null | sha256sum | cut -d' ' -f1 )
}

# --- sanitize: strip known secrets from every copied file --------------------
# state.db / sessions.json contain conversation transcripts which may hold
# API tokens typed in chat — replace them with REDACTED before backup so
# GitHub push protection never blocks the repo. MUST run before hashing/pushing.
sanitize_snapshot() {
  local dir="${1}" key val
  local secrets_file
  secrets_file=$(mktemp)
  if [ -f "${HERMES_HOME}/.env" ]; then
    grep -E '^[A-Za-z_][A-Za-z0-9_]*=' "${HERMES_HOME}/.env" 2>/dev/null >> "${secrets_file}" || true
  fi
  if [ -f "${HERMES_HOME}/.github_token" ]; then
    grep -E '^[A-Za-z_][A-Za-z0-9_]*=' "${HERMES_HOME}/.github_token" 2>/dev/null >> "${secrets_file}" || true
  fi
  while IFS='=' read -r key val; do
    [ -n "${key}" ] || continue
    val="${val%$'\r'}"
    val="${val#\"}"; val="${val%\"}"
    [ ${#val} -ge 6 ] || continue
    # binary-safe replacement of the secret value with REDACTED
    find "${dir}" -type f -print0 2>/dev/null \
      | xargs -0 perl -pi -e 'BEGIN{$s=shift @ARGV} s/\Q$s\E/REDACTED/g' -- "${val}" 2>/dev/null || true
  done < "${secrets_file}"
  rm -f "${secrets_file}"
}

# --- build fresh snapshot ------------------------------------------------------
rm -rf "${WORK_DIR}/snapshot"
mkdir -p "${WORK_DIR}/snapshot"
collect "${WORK_DIR}/snapshot"
sanitize_snapshot "${WORK_DIR}/snapshot"

file_count=$(find "${WORK_DIR}/snapshot" -type f 2>/dev/null | wc -l)
if [ "${file_count}" -eq 0 ] && [ "${FORCE}" -eq 0 ]; then
  # silent in auto mode (cron watchdog: empty stdout = nothing to report)
  exit 0
fi

# --- TEST mode: verify token + repo reachable, show what would be pushed ------
if [ "${TEST}" -eq 1 ]; then
  log "TEST mode — no push will happen"
  code=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "Authorization: token ${TOKEN}" https://api.github.com/user)
  log "GitHub API auth: HTTP ${code}"
  [ "${code}" = "200" ] || die "token rejected by GitHub API"
  log "Collected ${file_count} files"
  log "Current content hash: $(snapshot_hash "${WORK_DIR}/snapshot")"
  log "TEST OK"
  exit 0
fi

# --- AUTO mode: skip when content unchanged since last backup -----------------
if [ "${FORCE}" -eq 0 ] && [ -f "${STAMP_FILE}" ]; then
  prev_hash=$(cat "${STAMP_FILE}")
  cur_hash=$(snapshot_hash "${WORK_DIR}/snapshot")
  if [ "${prev_hash}" = "${cur_hash}" ]; then
    # silent in auto mode (cron watchdog: empty stdout = nothing to report)
    exit 0
  fi
fi

# --- push to GitHub --------------------------------------------------------------
AUTH_URL="https://x-access-token:${TOKEN}@$(echo "${REPO_URL}" | sed -E 's|^https?://||')"

rm -rf "${REPO_DIR}"
if git clone --quiet --depth 1 --branch "${BRANCH}" "${AUTH_URL}" "${REPO_DIR}" 2>/dev/null; then
  log "Cloned existing repo (branch ${BRANCH})"
else
  log "Clone failed — trying to init fresh (repo may be empty/uninitialized)"
  git init --quiet "${REPO_DIR}" && cd "${REPO_DIR}" \
    && git remote add origin "${AUTH_URL}" \
    && git checkout -q -b "${BRANCH}" \
    && cd - >/dev/null
fi

cd "${REPO_DIR}" || die "cannot cd to repo"
git config user.name  "Hermes Backup Bot"
git config user.email "hermes-backup@users.noreply.github.com"

# clear old tree, lay in new snapshot
rm -rf ./*
mkdir -p memories skills cron sessions state kanban
cp -a "${WORK_DIR}/snapshot"/. .

STAMP="$(date '+%Y%m%d-%H%M%S')"
git add -A
if git diff --cached --quiet; then
  log "No changes vs remote — nothing to push."
  cd - >/dev/null
  exit 0
fi
git commit -q -m "backup ${STAMP}" || die "commit failed"
if git push --quiet origin "${BRANCH}" 2>&1; then
  log "Backup pushed: ${STAMP} (${file_count} files)"
else
  # stale remote / fast-forward problem — retry once with full fetch+rebase
  log "Push failed — retrying with pull --rebase"
  git pull --quiet --rebase origin "${BRANCH}" 2>/dev/null && git push --quiet origin "${BRANCH}" || die "push failed after retry"
fi

# remember current content hash for next AUTO run (write only after success)
echo "$(snapshot_hash "${WORK_DIR}/snapshot")" > "${STAMP_FILE}"
log "Backup complete ✓"
cd - >/dev/null
exit 0
