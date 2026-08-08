---
name: hermes-state-backup
description: "Backup Hermes state to GitHub over HTTPS."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos]
metadata:
  hermes:
    tags: [backup, github, git, hermes, cron, watchdog, secrets]
---

# Hermes State Backup (memories → git remote)

Backs up Hermes persistent state (`memories/`, `skills/`, `cron/`, `kanban/`, `state.db`, sessions index, gateway state) to a GitHub repo over HTTPS — no SSH needed (port 22 may be closed). Implemented as a standalone bash script so it works both manually and as a cron `no_agent` watchdog.

## When to use
- User asks to back up Hermes memory/state to GitHub or another git remote.
- User asks for scheduled automatic backups (cron integration).
- Restoring a Hermes instance from a backup repo.

## Deployed reference implementation
- Script: `REDACTED/scripts/hermes-memory-backup.sh` (portable copy: `templates/hermes-memory-backup.sh` — change `REPO_URL`/`BRANCH` for other repos)
- Token: `REDACTED/.github_token` (`chmod 600`, format `GITHUB_TOKEN=ghp_...`) — also honored from env `GITHUB_TOKEN` or `HERMES_HOME/.env`
- Default target: `https://github.com/minakavoos291-glitch/MINAKavosii.git`, branch `main`

## Modes
- `--now` — force a backup regardless of change detection (user-requested).
- `--test` — verify token (GitHub API HTTP 200), build snapshot, print file count + hash, NO push. Always run this before the first real push.
- `auto` (no flag) — push ONLY if content changed since the last successful push (stamp file `last_content_hash`); fully silent when there is nothing to do.

## Cron watchdog integration (no_agent pattern)
1. `cronjob` action=create: schedule e.g. `every 3h`, `no_agent=true`, deliver origin. **The `script` parameter must be a BARE FILENAME relative to `~/.hermes/scripts/`** (e.g. `hermes-memory-backup.sh`) — absolute or `~`-prefixed paths are rejected at job creation ("Script path must be relative to ~/.hermes/scripts/").
2. The script is designed for this: empty stdout when nothing changed = silent tick (no message); non-zero exit = error alert; only real pushes/errors produce output. This is the classic watchdog shape — keep the no-op paths silent.

## What gets backed up (`collect`)
`memories/`, `skills/`, `cron/`, `kanban/`, `sessions/state.db`, `sessions/sessions.json`, `gateway_state.json`, `channel_directory.json`, `config.yaml`.
**Never** copy `.env`, `auth.json`, `.github_token` — credentials stay local; their values are used only for sanitization.

## Pitfalls (all hit in production — do not skip)
1. **Empty remote repo**: `git clone --depth 1 --branch main` FAILS on an empty repo. Fallback: `git init` + `git remote add origin <auth-url>` + `git checkout -q -b main`. Without the `remote add`, the first push fails with "origin does not appear to be a git repository".
2. **GitHub push protection (GH013)**: chat transcripts inside `state.db` contain pasted tokens (the user typed a PAT in chat). The first push is REJECTED with "Push cannot contain secrets". Fix: after collecting the snapshot, sanitize EVERY file with a binary-safe secret→`REDACTED` replace (see `sanitize_snapshot` in the template: `find ... -print0 | xargs -0 perl -pi -e 'BEGIN{$s=shift @ARGV} s/\Q$s\E/REDACTED/g' -- "$val"`). Collect secrets from `.env` + `.github_token` KEY=value lines; strip quotes/CRLF; skip values shorter than 6 chars. Sanitize BEFORE hashing and BEFORE pushing.
3. **Change detection**: compute the hash on the FRESH snapshot, compare only when the stamp file exists, and write the stamp AFTER a successful push. (Bug hit: hashing the stale snapshot made auto mode never detect changes.)
4. **Token extraction**: `.env` lines are `KEY=value` — strip the key prefix, surrounding quotes and `\r\n`. A token extracted WITH its `GITHUB_TOKEN=` prefix fails auth with "Invalid username or token". Verify with `--test` (expect `HTTP 200`) before any push attempt.
5. **Auth URL**: `https://x-access-token:${TOKEN}@github.com/owner/repo.git` pushes over HTTPS with a classic PAT (no SSH, works with port 22 closed).
6. **Verification after push**: `strings <repo>/sessions/state.db | grep -c '<token>'` must be 0 and the push must not have been blocked by push protection. Plain `grep` on the binary db LIES (reports matches that `strings`-based checks don't) — always use `strings | grep` for binary secret-scanning. Also confirm via GitHub API: `GET /repos/<owner>/<repo>/git/trees/main?recursive=1` shows the blob tree and `GET .../commits?per_page=1` shows message `backup <STAMP>`.

## Setup + verification steps
1. `chmod +x script && bash -n script` (syntax check).
2. `script --test` → expect `GitHub API auth: HTTP 200` and `TEST OK`.
3. `script --now` → expect `Backup pushed: <stamp> (<n> files)`.
4. Run `script` (auto) twice → second run silent (hash unchanged).
5. Make a change (e.g. add a memory entry), run auto again → pushes.

## Files
- `templates/hermes-memory-backup.sh` — the full working script; copy and adapt `REPO_URL`/`BRANCH`/`HERMES_HOME` for other deployments.
