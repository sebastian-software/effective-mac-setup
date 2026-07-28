# ADR 0002: Manage backup exclusions as explicit paths

## Status

Accepted.

## Context

Developer machines contain large, high-churn directories that are reproducible
from Git, package registries, application downloads, or setup scripts. Backing
them up wastes local Time Machine capacity, Backblaze bandwidth, and remote
storage while making useful restores harder to inspect.

The main offenders include:

- Git worktrees and project build products
- package-manager caches and downloaded toolchains
- Xcode build caches and Android SDK downloads
- local AI models
- container VM disks
- application caches

Broad rules based on file extensions are unsafe. A rule that excludes every
SQLite database, for example, also removes unique application data from the
backup.

Codex needs special treatment. Its home directory defaults to `~/.codex`, but
it is not just a cache. It contains local configuration and may contain local
chat transcripts, memories, rules, skills, automations, and other per-user
state. Local Codex conversations do not all sync to the cloud. The disposable
worktrees and runtime caches inside that directory can be excluded, but the
directory as a whole cannot.

## Decision

Store the desired paths in `macos/backup-exclusions.txt` and apply them with
`macos/backup-exclusions.sh`.

The script:

- resolves relative entries against the current user's home directory
- adds fixed-path exclusions with `tmutil addexclusion -p`
- configures Backblaze through its supported `bzcli configure` JSON interface
- checks both systems without changing them
- only adds desired paths and leaves unrelated user exclusions untouched

The whole `~/Workspace` directory is excluded by convention. Repositories are
expected to be recoverable from their Git remotes, and Codex worktrees under
`~/Workspace/.codex` are therefore covered automatically. This convention also
means uncommitted work under `~/Workspace` is not protected by either backup.

Within `~/.codex`, only reproducible runtime directories are excluded:

- worktrees
- caches and temporary plugin downloads
- the downloaded plugin app server
- the downloaded Computer Use helper app

Local sessions, archived sessions, memories, configuration, rules, skills,
automations, generated artifacts, and Codex state databases remain included.

Container VM disks are excluded. Persistent databases or volumes inside Colima
or Docker Desktop must be exported or backed up separately.

## Consequences

- A fresh Mac can converge on the same backup policy without clicking through
  two settings dialogs.
- Future cache paths can be added in one reviewable text file.
- `scripts/doctor.sh` can report drift.
- Backblaze must be installed and initialized before its exclusions can be
  applied.
- Time Machine fixed-path exclusions require `sudo` and Full Disk Access for
  the terminal that runs the script.
- Removing a line does not remove an existing exclusion automatically. This is
  deliberate: the script must not delete unrelated or previously intentional
  backup policy without an explicit removal operation.

## References

- [Codex config and state locations](https://learn.chatgpt.com/docs/config-file/config-advanced#config-and-state-locations)
- [Backblaze bzCLI](https://www.backblaze.com/computer-backup/docs/how-to-use-the-bzcli)
