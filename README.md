<div dir="rtl">

# دبی‌امید (DebiOmid): فارسی‌سازی دبیان ۱۳
پروژه‌ی «دبی‌امید» (ترکیبی از دبیان و امید) یک اسکریپت حرفه‌ای برای آماده‌سازی و فارسی‌سازی کامل دبیان ۱۳ (Trixie) است. این اسکریپت با استفاده از مخازن رسمی دبیان، فونت‌های باکیفیت، سیستم ورودی مدرن و تقویم جلالی را به سیستم شما اضافه می‌کند.

## ویژگی‌ها
- **تایپوگرافی مدرن:** نصب پکیج‌های رسمی `fonts-vazirmatn` و `fonts-noto-core` برای نمایش بی‌نقص متون فارسی.
- **تایپ فارسی:** تنظیم و پیکربندی **Fcitx5** به همراه موتور `m17n` برای دقیق‌ترین چیدمان کیبورد فارسی (استاندارد ISIRI 2901). کلید میانبر Alt+Shift به‌صورت خودکار تنظیم می‌شود و نیازی به پیکربندی دستی نیست.
- **تقویم جلالی:**
    - **در گنوم (GNOME):** نصب Extension Manager برای جستجو و نصب آسان افزونه تقویم جلالی.
    - **در کی‌دی‌ئی (KDE Plasma 6):** تنظیم خودکار ساعت سیستم برای نمایش تاریخ خورشیدی.
    - **در XFCE:** راهنمایی لازم برای افزودن Fcitx5 به برنامه‌های راه‌اندازی خودکار هنگام ورود به سیستم ارائه می‌شود.
- **فارسی‌سازی برنامه‌ها:** نصب بسته‌های زبان فارسی برای مرورگر **Firefox** و مجموعه **LibreOffice**.
- **استاندارد دبیان:** استفاده از `im-config` و تولید Localeهای سیستمی طبق استانداردهای رسمی دبیان.
- **بهینه‌سازی ترمینال:** اعمال تنظیمات لازم برای نمایش بهتر متون راست‌به‌چپ در محیط ترمینال.
- **بررسی نسخه سیستم:** اسکریپت به‌طور خودکار نسخه دبیان را تشخیص می‌دهد و در صورتی که سیستم شما دبیان ۱۳ (Trixie) نباشد، قبل از ادامه از شما تأیید می‌گیرد.
- **ذخیره گزارش نصب:** تمام خروجی اسکریپت در مسیر `/var/log/debiomid-install.log` ذخیره می‌شود تا در صورت بروز هر مشکلی بتوانید آن را بررسی کنید.

---

## نصب

برای نصب دبی‌امید (DebiOmid) روی دبیان ۱۳ (Trixie)، مراحل زیر را دنبال کنید:

**۱. اجرای اسکریپت نصب**

ترمینال خود را باز کرده و دستور زیر را اجرا کنید:

```bash
wget -O- https://raw.githubusercontent.com/delejos/DebianOmid/main/setup.sh | sudo bash
```

> اگر سیستم شما دبیان ۱۳ نباشد، اسکریپت یک هشدار نمایش داده و از شما می‌پرسد که آیا می‌خواهید ادامه دهید یا نه.

**۲. اعمال تغییرات**

پس از پایان کار اسکریپت، یک‌بار از سیستم خارج (Logout) و دوباره وارد (Login) شوید تا تمام تغییرات اعمال شوند.

**۳. تنظیم صفحه‌کلید فارسی (در صورت نیاز)**

کلید میانبر Alt+Shift به‌صورت خودکار پیکربندی شده است. در صورت نیاز به تغییر، برنامه **Fcitx5 Configuration** را باز کرده و از تب **Global Options** کلید میانبر دلخواه را تنظیم کنید.

**۴. فعال‌سازی تقویم جلالی (فقط برای کاربران گنوم)**

برنامه **Extension Manager** را باز کنید، به تب **Browse** بروید و عبارت **Persian Calendar** را جستجو کرده و نصب کنید.

---

## عیب‌یابی

اگر هنگام نصب مشکلی پیش آمد، فایل گزارش زیر را بررسی کنید:

```bash
cat /var/log/debiomid-install.log
```

---

## حذف (Uninstall)

```bash
wget -O- https://raw.githubusercontent.com/delejos/DebianOmid/main/uninstall.sh | sudo bash
```

---

## لایسنس
این پروژه تحت لایسنس MIT منتشر شده است.

</div>

---

# DebiOmid: Debian 13 (Trixie) Farsi Localization

DebiOmid (Debian + Omid/Hope) is a professional post-install script designed to perfectly localize Debian 13 (Trixie) for Farsi-speaking users. It automates the installation of high-quality fonts, input methods, and calendar systems using 100% official Debian repositories.

---

## Features
- **Modern Typography:** Installs official `fonts-vazirmatn` and `fonts-noto-core` for crisp Persian rendering.
- **Improved Typing:** Sets up **Fcitx5** with the `m17n` backend for accurate Persian (ISIRI 2901) keyboard layouts. The Alt+Shift toggle is pre-configured automatically — no manual GUI setup needed.
- **Jalali Calendar:**
    - **GNOME:** Installs Extension Manager to easily find and install the Jalali Calendar extension.
    - **KDE Plasma 6:** Automatically configures the system clock to use the Persian calendar.
    - **XFCE:** Provides guidance for adding Fcitx5 to your session autostart.
- **App Localization:** Installs Persian language packs for **Firefox-ESR** and **LibreOffice**.
- **System Standards:** Uses `im-config` and official locale generation to ensure system stability.
- **Terminal Optimization:** Optimizes RTL text rendering hints for modern terminal emulators.
- **Debian Version Check:** The script automatically detects your Debian version and prompts for confirmation before proceeding if you are not on Debian 13 (Trixie).
- **Install Logging:** All script output is saved to `/var/log/debiomid-install.log` so you have a full record if anything goes wrong.

---

## Installation

**1. Run the installation script**

Open your terminal and run:

```bash
wget -O- https://raw.githubusercontent.com/delejos/DebianOmid/main/setup.sh | sudo bash
```

> If your system is not Debian 13 (Trixie), the script will display a warning and ask whether you want to continue.

**2. Apply changes**

Once the script finishes, log out and log back in (or restart) to activate the new environment variables and input method framework.

**3. Verify the Persian keyboard (if needed)**

Alt+Shift is pre-configured as the language toggle. If you want to change it, open **Fcitx5 Configuration** and check the **Global Options** tab.

**4. Enable Jalali Calendar (GNOME users only)**

Open the **Extension Manager** app, go to the **Browse** tab, and search for **"Persian Calendar"** to install it.

---

## Troubleshooting

If the installation fails or something doesn't work, check the log file:

```bash
cat /var/log/debiomid-install.log
```

---

## Uninstall

```bash
wget -O- https://raw.githubusercontent.com/delejos/DebianOmid/main/uninstall.sh | sudo bash
```

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

This project is licensed under the MIT License.
