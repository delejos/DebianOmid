#!/bin/bash

# ==========================================================================
# Script Name: setup.sh (DebiOmid)
# Description: Professional Farsi Localization for Debian 13 (Trixie)
# GitHub:      github.com/delejos/DebiOmid
# Author:      delejos
# Version:     1.1.0
# ==========================================================================

set -euo pipefail

LOG_FILE="/var/log/debiomid-install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

# Cleanup/error trap
cleanup() {
    local exit_code=$?
    if [ "$exit_code" -ne 0 ]; then
        echo ""
        echo "❌ Installation failed at an unexpected step (exit code: $exit_code)."
        echo "خطا: نصب به دلیل یک مشکل پیش‌بینی‌نشده متوقف شد."
        echo "Log saved to: $LOG_FILE"
    fi
}
trap cleanup EXIT

# ---------------------------------------------------------------------------
# 1. Root check
# ---------------------------------------------------------------------------
if [ "$EUID" -ne 0 ]; then
    echo "❌ Error: Please run as root (use sudo)."
    echo "خطا: لطفا اسکریپت را با دسترسی root اجرا کنید."
    exit 1
fi

# ---------------------------------------------------------------------------
# 2. Debian version check
# ---------------------------------------------------------------------------
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "${ID:-}" != "debian" ]; then
        echo "⚠️  Warning: This script is designed for Debian. Detected OS: ${ID:-unknown} ${VERSION_CODENAME:-}"
        echo "هشدار: این اسکریپت برای دبیان طراحی شده است."
        read -r -p "Continue anyway? (y/N): " confirm
        [[ "$confirm" =~ ^[Yy]$ ]] || exit 1
    elif [ "${VERSION_CODENAME:-}" != "trixie" ]; then
        echo "⚠️  Warning: This script targets Debian 13 (Trixie). Detected: ${VERSION_CODENAME:-unknown}"
        echo "هشدار: این اسکریپت برای دبیان ۱۳ (Trixie) طراحی شده است. نسخه شناسایی‌شده: ${VERSION_CODENAME:-نامشخص}"
        read -r -p "Continue anyway? (y/N): " confirm
        [[ "$confirm" =~ ^[Yy]$ ]] || exit 1
    fi
fi

# Resolve the real user (the one who invoked sudo)
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

echo "-----------------------------------------------------------"
echo "🌟 Starting DebiOmid: Farsi Localization for Debian 13 🌟"
echo "   Installing for user : $REAL_USER"
echo "   Log file            : $LOG_FILE"
echo "-----------------------------------------------------------"

# ---------------------------------------------------------------------------
# 3. Prerequisites
# ---------------------------------------------------------------------------
echo "🔍 [1/7] Updating repositories and installing prerequisites..."
apt-get update -q
apt-get install -y curl wget unzip git locales im-config

# ---------------------------------------------------------------------------
# 4. System locale
# ---------------------------------------------------------------------------
echo "🌍 [2/7] Generating Persian locale (fa_IR.UTF-8)..."
# Only uncomment the locale line if it is still commented out (idempotent)
if grep -q "^# fa_IR.UTF-8 UTF-8" /etc/locale.gen; then
    sed -i 's/^# fa_IR.UTF-8 UTF-8/fa_IR.UTF-8 UTF-8/' /etc/locale.gen
fi
locale-gen
echo "✅ Locales generated."

# ---------------------------------------------------------------------------
# 5. Fonts
# ---------------------------------------------------------------------------
echo "🔤 [3/7] Installing Farsi fonts (Vazirmatn & Noto Core)..."
apt-get install -y fonts-vazirmatn fonts-vazirmatn-variable fonts-noto-core fonts-freefarsi

# ---------------------------------------------------------------------------
# 6. Input method (Fcitx5)
# ---------------------------------------------------------------------------
echo "⌨️  [4/7] Setting up Fcitx5 for Persian typing..."
apt-get install -y fcitx5 fcitx5-m17n fcitx5-config-qt fcitx5-frontend-gtk3 fcitx5-frontend-qt6

# Write IME environment variables to a dedicated profile.d file so we never
# clobber any existing content in /etc/environment.
IME_ENV_FILE="/etc/profile.d/debiomid_ime.sh"
cat > "$IME_ENV_FILE" << 'EOF'
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
EOF
chmod 644 "$IME_ENV_FILE"

# Register fcitx5 as the system-wide input method via Debian's im-config
im-config -n fcitx5

# Pre-configure the Persian (ISIRI 2901) keyboard layout for the real user
# so that no manual GUI setup is needed after reboot.
FCITX5_CFG="$REAL_HOME/.config/fcitx5"
if [ ! -f "$FCITX5_CFG/profile" ]; then
    mkdir -p "$FCITX5_CFG/conf"
    cat > "$FCITX5_CFG/profile" << 'EOF'
[Groups/0]
Name=Default
Default Layout=keyboard-us
DefaultIM=m17n:fa:isiri

[Groups/0/Items/0]
Name=keyboard-us
Layout=

[Groups/0/Items/1]
Name=m17n:fa:isiri
Layout=

[GroupOrder]
0=Default
EOF
    cat > "$FCITX5_CFG/conf/global.conf" << 'EOF'
[Hotkey]
# Toggle input method: Alt+Shift
TriggerKeys=Alt+Shift_L
EOF
    chown -R "$REAL_USER:$REAL_USER" "$FCITX5_CFG"
    echo "✅ Persian keyboard (Alt+Shift) pre-configured for $REAL_USER."
else
    echo "ℹ️  Existing Fcitx5 profile found — skipping auto-configuration to avoid overwriting your settings."
fi

# ---------------------------------------------------------------------------
# 7. Desktop-environment tweaks
# ---------------------------------------------------------------------------
DESKTOP_ENV="${XDG_CURRENT_DESKTOP:-unknown}"
echo "🎨 [5/7] Applying desktop-specific settings (detected: $DESKTOP_ENV)..."

if [[ "$DESKTOP_ENV" == *"GNOME"* ]]; then
    apt-get install -y gnome-shell-extension-manager
    echo "💡 Hint: Open 'Extension Manager' after reboot, go to Browse, and search for 'Jalali'."

elif [[ "$DESKTOP_ENV" == *"KDE"* ]]; then
    if command -v kwriteconfig6 >/dev/null 2>&1 && [ -n "${SUDO_USER:-}" ]; then
        su - "$SUDO_USER" -c "kwriteconfig6 --file kdeglobals --group Locale --key CalendarSystem persian"
        echo "✅ KDE calendar set to Persian (Jalali)."
    else
        echo "⚠️  kwriteconfig6 not found or not running via sudo — skipping KDE calendar config."
    fi

elif [[ "$DESKTOP_ENV" == *"XFCE"* ]]; then
    apt-get install -y xfce4-session
    echo "💡 Hint: Go to Settings → Session and Startup, add 'fcitx5 --replace' as a startup application."

else
    echo "ℹ️  Desktop environment '$DESKTOP_ENV' not specifically handled."
    echo "    After reboot, add 'fcitx5 --replace &' to your session's autostart."
fi

# ---------------------------------------------------------------------------
# 8. Application localisation
# ---------------------------------------------------------------------------
echo "📦 [6/7] Installing Persian language packs..."
apt-get install -y firefox-esr-l10n-fa libreoffice-l10n-fa

# ---------------------------------------------------------------------------
# 9. Terminal RTL optimisation
# ---------------------------------------------------------------------------
echo "💻 [7/7] Optimising terminal for RTL text rendering..."
RTL_ENV_FILE="/etc/profile.d/debiomid_terminal.sh"
cat > "$RTL_ENV_FILE" << 'EOF'
export VTE_CJK_WIDTH=1
EOF
chmod 644 "$RTL_ENV_FILE"

echo ""
echo "-----------------------------------------------------------"
echo "🎉 Setup complete! / عملیات با موفقیت انجام شد"
echo "-----------------------------------------------------------"
echo "Next steps:"
echo "  1. Log out and log back in (or restart) to activate all changes."
echo "  2. Persian keyboard (Alt+Shift) has been pre-configured."
echo "     Open 'Fcitx5 Configuration' to adjust if needed."
if [[ "${DESKTOP_ENV:-}" == *"GNOME"* ]]; then
echo "  3. Open 'Extension Manager', go to Browse, and install 'Persian Calendar'."
fi
echo ""
echo "Log saved to: $LOG_FILE"
echo "-----------------------------------------------------------"
