# Zed (declarative)

Zed is configured declaratively through `home-manager` as part of HornHead.

## Files

| File | Purpose |
| --- | --- |
| `settings.json` | Canonical Zed settings (strict JSON, no comments). |
| `keymap.json` | Canonical Zed keybindings (strict JSON array). |
| `../zed.nix` | Home-manager module (`self.homeModules.zed`) that loads the two files above. |
| `../home-manager.nix` | Wires home-manager into the NixOS hosts. |

`settings.json` / `keymap.json` are the single source of truth. Nix reads them
with `builtins.fromJSON`, so they must stay valid JSON (no `//` comments).

## Linux (HornHead)

Managed automatically on `nixos-rebuild switch`, which places them at
`~/.config/zed/`. `mutableUserSettings` / `mutableUserKeymaps` are enabled, so
Zed can still edit these files at runtime; Nix re-merges the managed keys on the
next rebuild and backs up conflicts as `*.hm-backup`.

A `zed` command is also installed (the nixpkgs package only ships `zeditor`), so
`zed .` opens the current folder.

## Windows (portable)

Copy the two canonical files to the Windows config directory:

```powershell
# from the HornHead repo
Copy-Item .\modules\features\zed\settings.json "$env:APPDATA\Zed\settings.json" -Force
Copy-Item .\modules\features\zed\keymap.json   "$env:APPDATA\Zed\keymap.json"   -Force
```

Extensions install automatically on first launch thanks to
`auto_install_extensions` (needs network). For the Nerd Font icons, install
**JetBrainsMono Nerd Font** on Windows as well. The Rosé Pine theme is pulled in
by the `rose-pine-theme` extension.

> `theme_overrides` requests a transparent background to match the Neovim setup;
> this may only render on some platforms.
