# TODO List

- [x] Import Zed config into NixOS HornHead via home-manager
  - `modules/features/zed.nix` (`flake.homeModules.zed`) + `modules/features/home-manager.nix`
  - Canonical config lives in `modules/features/zed/settings.json` and `keymap.json`
  - Linux: auto-applied to `~/.config/zed` on rebuild
  - Windows: copy the two JSON files to `%APPDATA%\Zed\`
- [x] Update the EOSVault Obsidian vault with a Zed section
  - `Zed/cheatsheet.md` (keybinds)
  - `Zed/README.md` (Nix / home-manager setup + Windows copy)
  - `Zed/settings.md` (options explained + nvim counterparts)
  - `Zed/extensions.md` (extensions + LSP mapping)
  - NOTE: files created but not yet committed in the EOSVault repo
- [ ] Adjust wallpapers so that I have a couple I like and then set them as the
  default
