# Contributing to DebianOmid

Thank you for your interest in improving DebianOmid!

## How to contribute

1. **Fork** the repository and create a branch from `main`.
2. **Make your changes.** Keep the scope focused — one fix or feature per pull request.
3. **Test your changes** on a clean Debian 13 (Trixie) install before submitting.
4. **Open a pull request** with a clear description of what you changed and why.

## Script guidelines

- All shell scripts must pass [ShellCheck](https://www.shellcheck.net/) with no errors or warnings.
- Keep user-facing messages bilingual (English + Farsi) to match the project's style.
- Do not overwrite system files (e.g. `/etc/environment`) in full — append or use dedicated files in `/etc/profile.d/`.
- Scripts should be idempotent: safe to run more than once without causing duplicate configuration.

## Reporting bugs

Open a [GitHub issue](https://github.com/delejos/DebianOmid/issues) and include:
- Your Debian version (`cat /etc/os-release`)
- Your desktop environment
- The full terminal output or the contents of `/var/log/debiomid-install.log`

## Suggesting features

Open an issue describing the feature and why it would benefit Farsi-speaking Debian users.
