# ADR 0001: Curate macOS settings instead of exporting all preferences

## Status

Accepted.

## Context

macOS does not provide a reliable command that lists only settings changed from the factory defaults.

`defaults` and `~/Library/Preferences/*.plist` show persisted values, but persisted does not mean intentionally changed. Many values are caches, timestamps, window positions, recent items, Apple ID/iCloud state, runtime metadata, or app-internal state written during normal use.

Some settings are also outside `defaults`, for example:

- Configuration Profiles
- TCC and privacy permissions
- Keychain and account state
- Apple ID and iCloud state
- app databases and private system stores

Blindly exporting preferences would make this repository noisy, fragile, and likely to contain machine-specific or stale state.

## Decision

Do not export all macOS preferences.

When a macOS setting should become reproducible:

1. Name the desired behavior in plain language.
2. Find the smallest supported mechanism for it.
3. Prefer `defaults write` for simple user defaults.
4. Use Configuration Profiles only for settings that are naturally policy-like.
5. Keep secrets, account state, privacy permissions, and volatile app state out of the repo.
6. Document the setting next to the command that applies it.

If macOS settings are added later, they should live in a small, reviewed script such as:

```text
macos/defaults.sh
```

Each entry should explain what it changes, why it is wanted, and the relevant domain/key.

## Consequences

- The setup stays understandable and portable.
- We avoid committing large preference dumps and machine-specific state.
- Adding macOS settings requires small manual research per setting.
- Auditing current preferences can still be useful, but only as input for curation, not as source of truth.
