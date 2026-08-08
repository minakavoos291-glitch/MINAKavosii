---
name: github-state-backup
description: "Back up local state to GitHub via PAT, redacting secrets."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos]
metadata:
  hermes:
    tags: [github, backup, secrets, cron, watchdog, git, redaction]
---

# GitHub State Backup (secret-safe)

Push local agent/user state (memory files, SQLite DBs, config, skills) to a GitHub repo as an automated offsite backup. Validated end-to-end: snapshot → redact secrets → commit → push, wired to a silent cron watchdog.

## When to use

- User wants automatic backups of Hermes memory/sessions to their GitHub repo
- Any "push state to GitHub" task where the data may contain API tokens, chat transcripts, or credentials
- Push is rejected by GitHub with `GH013` / "Push cannot contain secrets" (Push Protection)

## Key facts

- **Port 22 closed / no SSH** → authenticate via HTTPS URL with the token embedded: `https://x-access-token:${TOKEN}@github.com/<owner>/<repo>.git`. Never reach for SSH in restricted environments.
- **Push Protection scans every blob** — including binary `state.db` files holding chat transcripts. If the user ever typed a token in chat, it is in the DB and a plain push is blocked. The fix is redaction *before* commit, not excluding files (the DB is exactly what you want to back up).
- **Never back up credential stores** (`.env`, `auth.json`, token files). Exclude them from the snapshot entirely; scrub their *values* out of everything else.
- **Empty repo** (no commits, or no `main` branch): `git clone --branch main` fails → fall back to `git init` + `git remote add origin <auth-url>` + `git checkout -q -b main`.
- **Token file gotcha:** store the raw token (no `KEY=` prefix) or handle the prefix in the reader. Strip surrounding quotes and `\r\n` after extraction.
- **Watchdog cron pattern:** `no_agent=true` cron with a script; script exits `0` with **empty stdout** when nothing changed (silent = no delivery), logs only on real change/error, non-zero exit = error alert.

## Workflow

1. **Resolve token** (env → `$HERMES_HOME/.env` → `$HERMES_HOME/.github_token`), strip quotes/CRLF.
2. **Collect snapshot**: copy memories/, skills/, cron/, kanban/, state.db, sessions index, gateway state, config.yaml into a temp dir. Exclude `.env`, `auth.json`, token files.
3. **Sanitize**: gather every `KEY=value` from the env/token files and binary-safely replace each value with `REDACTED` across all snapshot files (perl `-pi -e 's/\Q$s\E/REDACTED/g'` via `find -print0 | xargs -0 perl -pi`). Needed because the SQLite transcript DB contains the values.
4. **Hash**: `find . -type f -print0 | sort -z | xargs -0 sha256sum | sha256sum` for change detection. In auto mode, compare against a stamp file; unchanged → silent exit 0.
5. **Push**: clone (or init-fresh fallback), replace tree with snapshot, commit `backup <timestamp>`, push; on non-fast-forward retry once with `git pull --rebase`.
6. **Verify externally**: list the tree via `GET /repos/{o}/{r}/git/trees/{branch}?recursive=1` and check the latest commit via `GET /repos/{o}/{r}/commits?per_page=1`. Never trust the push exit code alone.
7. **Scan the pushed snapshot** for secrets with `strings state.db | grep <pattern>` (binary-safe; plain grep on a DB lies).

## Cron watchdog wiring

- Script must live under `~/.hermes/scripts/`; cron `script` field takes the **bare filename** (absolute paths are rejected).
- Create: `cronjob action=create, no_agent=true, schedule="every 3h", script=<name>.sh, prompt=<ignored>`, deliver to origin. `no_agent=true` = zero tokens; only stdout is delivered.
- Manual runs: `--now` (force), `--test` (dry-run: API auth check + file count + hash, no push).

## Pitfalls

- `git clone --branch main` on an empty repo fails with "Could not read from remote repository" — that's the empty-repo signal, not an auth failure. Check token separately via `curl -H "Authorization: token $TOKEN" https://api.github.com/user` (expect HTTP 200).
- First push of a fresh `git init` branch needs the remote added **before** `git checkout -b`, or `git push origin main` has no upstream (`fatal: 'origin' does not appear to be a git repository`).
- Cloning with an embedded token leaks it into `.git/config` of the temp clone — fine for `/tmp` scratch, but `rm -rf` the clone after pushing.
- Push Protection error is reported at push time, not at clone time — always scan the snapshot for secrets *before* the first push to avoid a rejected-history dead end.
- `git diff --cached --quiet` detects "no change vs remote" → skip commit/push (keeps watchdog history clean).

## Files

- `scripts/hermes-memory-backup.sh` — proven full implementation (copy & adapt: change `REPO_URL`, branch, and collected paths).
- `references/push-protection.md` — GH013 error transcript and the redaction fix.
