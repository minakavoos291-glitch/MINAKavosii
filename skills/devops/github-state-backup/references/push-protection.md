# GitHub Push Protection (GH013) — transcript & fix

## The failure

First push of a state snapshot (containing `sessions/state.db`, i.e. the SQLite
session/transcript store) to a repo with Push Protection enabled:

```
remote: error: GH013: Repository rule violations found for refs/heads/main.
remote: - GITHUB PUSH PROTECTION
remote:   - Push cannot contain secrets
remote:       —— GitHub Personal Access Token ——————————————————————
remote:        locations:
remote:          - commit: 283fa21ab62e9f3bc2f040d4c6fe1d644633f556
remote:            path: sessions/state.db:500
remote:            ...
! [remote rejected] main -> main (push declined due to repository rule violations)
error: failed to push some refs
```

## Why

Push Protection scans **every pushed blob**, binary files included. A user who
pasted a GitHub PAT into chat had that token stored inside the conversation
transcript — which lives in `state.db`. The DB is a core thing you want to back
up, so excluding it is the wrong fix.

## The fix (validated)

Redact the secret values *before* committing, across all snapshot files,
binary-safe:

```bash
# collect every KEY=value from env/token files
grep -E '^[A-Za-z_][A-Za-z0-9_]*=' "$HERMES_HOME/.env" > /tmp/secrets
# for each value V (strip quotes/CRLF, skip <6 chars):
find /path/to/snapshot -type f -print0 \
  | xargs -0 perl -pi -e 'BEGIN{$s=shift @ARGV} s/\Q$s\E/REDACTED/g' -- "$V"
```

Then the push succeeds with the same file set intact (`REDACTED` in place of the
secret inside the transcripts).

## Verification

- `strings sessions/state.db | grep -c '<token>'` must be 0 (plain `grep` on a
  binary DB reports false hits — use `strings`).
- GitHub provides an "allow secret" URL in the error when you accept the risk;
  do NOT use it — redaction is the correct path so future pushes stay clean.

## Other gotchas hit on the same path

- `git clone --branch main <auth-url>` fails on an **empty** repo with
  "Could not read from remote repository" — that is the empty-repo signal.
- Fresh `git init` fallback needs `git remote add origin <auth-url>` BEFORE
  `git checkout -b main`, or the first `git push origin main` has no upstream.
- Token embedded in clone URL lands in the temp clone's `.git/config` — `rm -rf`
  the clone after pushing.
- Token in `.github_token` file: store raw value or strip the `GITHUB_TOKEN=`
  prefix in the reader; also strip quotes and CR/LF.
