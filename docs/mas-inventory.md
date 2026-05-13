# Mac App Store Inventory

Date: 2026-05-13

`mas` is installed through Homebrew:

```text
mas 7.0.0
```

`mas config` works and reports:

```text
store: DE
region: DE
macOS: 26.5 (25F71)
architecture: arm64
```

`mas list` was attempted during setup. It did not return and was stopped manually.

Installed Mac App Store apps were therefore reconstructed from local app receipts and Spotlight metadata.

## Tracked Apps

These entries are now tracked in the Brewfile:

```ruby
mas "Pages", id: 361309726
mas "Keynote", id: 361285480
mas "Numbers", id: 361304891
mas "Microsoft Word", id: 462054704
mas "Microsoft Excel", id: 462058435
mas "Microsoft PowerPoint", id: 462062816
mas "Xcode", id: 497799835
mas "Things", id: 904280696
mas "Fantastical", id: 975937182
mas "Lungo", id: 1263070803
mas "Tailscale", id: 1475387142
mas "1Password for Safari", id: 1569813296
mas "Velja", id: 1607635845
mas "Pure Paste", id: 1611378436
mas "PingZilla", id: 6757017560
```

## Next Step

Run this again later on a stable connection:

```sh
mas list
```

Then compare the output with the Brewfile entries above.
