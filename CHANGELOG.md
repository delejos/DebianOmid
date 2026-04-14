# Changelog

All notable changes to DebiOmid are documented here.

---

## [1.1.0] - 2026-04-13

### Added
- **Debian version check** — script warns and prompts before running on non-Trixie systems.
- **Install logging** — full output is saved to `/var/log/debiomid-install.log` for troubleshooting.
- **Error trap** — a cleanup handler prints a clear failure message and points to the log file if anything goes wrong.
- **Automated Fcitx5 configuration** — Persian (ISIRI 2901) keyboard layout and Alt+Shift toggle are pre-configured for the real user; no manual GUI setup required after reboot.
- **XFCE support** — detects XFCE and provides session autostart guidance.
- **`uninstall.sh`** — interactive script to fully remove all packages and configuration files added by DebiOmid.
- **`.gitignore`** — standard exclusions for editor temp files and OS metadata.
- **`CONTRIBUTING.md`** — contribution guidelines and bug reporting instructions.
- **ShellCheck CI** (`.github/workflows/lint.yml`) — automatically lints all shell scripts on every push and pull request.

### Changed
- IME environment variables are now written to `/etc/profile.d/debiomid_ime.sh` instead of overwriting `/etc/environment`, preventing accidental loss of other system variables.
- RTL terminal settings moved to `/etc/profile.d/debiomid_terminal.sh` (was already there, now consistently named).
- `apt` replaced with `apt-get` throughout for non-interactive script use.
- `set -e` upgraded to `set -euo pipefail` for stricter error handling.
- README restructured: Farsi section first, English section second; install commands now use proper code fences; numbered steps corrected.

### Fixed
- Skipped step number in English README installation steps (jumped from step 2 to step 4).
- Install command in README was not inside a code block.

---

## [1.0.0] - 2026-02-21

### Added
- Initial release.
- Farsi locale generation (`fa_IR.UTF-8`).
- Vazirmatn and Noto Core font installation.
- Fcitx5 + m17n input method setup.
- GNOME Extension Manager installation for Jalali calendar.
- KDE Plasma 6 Jalali calendar auto-configuration.
- Firefox-ESR and LibreOffice Farsi language packs.
- Terminal RTL optimisation via `VTE_CJK_WIDTH`.
- Bilingual (English + Farsi) README.
