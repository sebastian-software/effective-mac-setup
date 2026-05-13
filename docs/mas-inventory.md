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

`mas list` was attempted during the first setup while on an unstable train connection. It did not return and was stopped manually.

## Next Step

Run this again on a stable connection:

```sh
mas list
```

Then review the output before adding any entries to the Brewfile:

```ruby
mas "App Name", id: 123456789
```
