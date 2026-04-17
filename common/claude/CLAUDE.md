# Global Claude Code Instructions

## Shell command preferences

Prefer `rg` (ripgrep) over `grep`, `fd` over `find`, `rip` over `rm`, and `k` over `ls`:

- Use `rg` for content search — it is recursive by default and handles flag translation correctly (e.g. `--include="*.py"` becomes `-g "*.py"`, `-H` is redundant as filenames are shown by default).
- Use `fd` for file search — use `-e` for extensions, `-t` for type filtering.
- Use `rip` for file/directory deletion instead of `rm` — it moves to a graveyard and is recoverable.
- Use `k` instead of `ls` for directory listings — it shows git status and file metadata.
- Fall back to `grep`, `find`, `rm`, or `ls` when the use case is not supported by the above (e.g. `find` for `-mtime`, `-exec` chains, or `-perm` filters that `fd` does not cover).

## Docker Compose projects

Most projects are fully containerized. General pattern:
- Compose files live in `docker/` at the repo root (`docker-compose.yml` base + `docker-compose.dev.yml` overlay)
- A `Makefile` wraps the compose invocation — always check it first for available targets
- Use `make exec CMD="..."` to run arbitrary commands inside the app container
- Use `make test ARGS="..."` to run the test suite
- Use `make migrate` / `make makemigrations` for Django migrations
- Inside containers, Python commands use `uv run` (not bare `python`)
- When the Makefile covers a task, prefer it over raw `docker compose` commands
