#!/bin/bash

# ==========================================================================
# Script Name: uninstall.sh (DebianOmid)
# Description: Removes DebianOmid Farsi Localization from Debian 13 (Trixie)
# GitHub:      github.com/delejos/DebianOmid
# Author:      delejos
# ==========================================================================

set -euo pipefail

if [ "$EUID" -ne 0 ]; then
    echo "❌ Error: Please run as root (use sudo)."
    echo "خطا: لطفا اسکریپت را با دسترسی root اجرا کنید."
    exit 1
fi

REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

echo "-----------------------------------------------------------"
echo "🗑️  DebianOmid Uninstaller"
echo "   This will remove the Farsi localization packages and"
echo "   configuration files installed by DebianOmid."
echo "   این عملیات بسته‌ها و تنظیمات فارسی‌سازی DebianOmid را حذف می‌کند."
echo "-----------------------------------------------------------"
read -r -p "Are you sure you want to continue? (y/N): " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

# ---------------------------------------------------------------------------
# Remove packages
# ---------------------------------------------------------------------------
echo ""
echo "📦 Removing packages..."
PACKAGES=(
    fcitx5
    fcitx5-m17n
    fcitx5-config-qt
    fcitx5-frontend-gtk3
    fcitx5-frontend-qt6
    fonts-vazirmatn
    fonts-vazirmatn-variable
    fonts-noto-core
    fonts-freefarsi
    firefox-esr-l10n-fa
    libreoffice-l10n-fa
    gnome-shell-extension-manager
)
apt-get remove -y --purge "${PACKAGES[@]}" 2>/dev/null || true
apt-get autoremove -y

# ---------------------------------------------------------------------------
# Remove profile.d environment files
# ---------------------------------------------------------------------------
echo "🧹 Removing DebianOmid environment files..."
rm -f /etc/profile.d/debianomid_ime.sh
rm -f /etc/profile.d/debianomid_terminal.sh
echo "✅ Environment files removed."

# ---------------------------------------------------------------------------
# Optionally remove Fcitx5 user config
# ---------------------------------------------------------------------------
FCITX5_CFG="$REAL_HOME/.config/fcitx5"
if [ -d "$FCITX5_CFG" ]; then
    read -r -p "Remove Fcitx5 user config at $FCITX5_CFG? (y/N): " remove_cfg
    if [[ "$remove_cfg" =~ ^[Yy]$ ]]; then
        rm -rf "$FCITX5_CFG"
        echo "✅ Fcitx5 user configuration removed."
    else
        echo "ℹ️  Fcitx5 user config kept."
    fi
fi

# ---------------------------------------------------------------------------
# Remove install log (optional)
# ---------------------------------------------------------------------------
if [ -f /var/log/debianomid-install.log ]; then
    read -r -p "Remove install log (/var/log/debianomid-install.log)? (y/N): " remove_log
    if [[ "$remove_log" =~ ^[Yy]$ ]]; then
        rm -f /var/log/debianomid-install.log
        echo "✅ Install log removed."
    fi
fi

echo ""
echo "-----------------------------------------------------------"
echo "✅ DebianOmid has been removed. Please restart your system."
echo "   حذف انجام شد. لطفاً سیستم را ری‌استارت کنید."
echo "-----------------------------------------------------------"
