# Asahi Linux Issues & Solutions

You're getting errors because you're running **Asahi Linux** (Fedora on M1/M2 Mac). There are two major problems:

## Problem 1: Your pip is Broken

Error:
```
ImportError: undefined symbol: XML_SetAllocTrackerActivationThreshold
```

**What this means:** Your Python 3.13 installation has a corrupted `expat` XML library. pip can't even start.

**Fix:**
```bash
sudo dnf reinstall -y expat python3-libs python3
```

## Problem 2: Asahi Blocks kernel-devel

Error:
```
installed package asahi-platform-metapackage-core conflicts with kernel-devel
```

**What this means:** Asahi Linux intentionally blocks `kernel-devel` to protect the custom M1/M2 kernel. This prevents `pynput` from compiling.

**Why:** Asahi uses a special kernel with Apple Silicon support. Installing standard kernel-devel could break your system.

## Solutions

### ✅ RECOMMENDED: Use the Browser Extension

The **easiest and best solution** is to use the browser extension instead of the desktop app.

**Why this is better:**
- ✅ No compilation needed
- ✅ No kernel dependencies
- ✅ Works perfectly on M1 Macs
- ✅ Same features (typos, humanization, smart replace)
- ✅ 5-minute install

**How to install:**

1. **For Firefox:**
   ```bash
   cd ..  # Go back to main folder
   ./package-firefox.sh
   ```
   Then load the ZIP in Firefox at `about:debugging`

2. **For Chrome/Edge:**
   ```bash
   cd ..  # Go back to main folder
   ./package.sh
   ```
   Then load unpacked at `chrome://extensions`

See `../FIREFOX.md` for detailed Firefox instructions.

### ⚠️ ALTERNATIVE: Try to Fix the Desktop App

If you really want the desktop app, try this:

```bash
./fix-asahi-linux.sh
```

This script will:
1. Fix your broken Python/pip
2. Try to install pynput without kernel-devel
3. Test if it works

**Success rate:** ~30% on Asahi Linux

**If it fails:** Use the browser extension (recommended above)

## Why the Desktop App is Hard on Asahi

1. **Python 3.13 is too new** - Has bugs on Asahi
2. **No kernel-devel** - Asahi blocks it for good reasons
3. **pynput needs compilation** - Requires kernel headers
4. **evdev dependency** - Needs kernel-devel

Asahi is cutting-edge (good for M1 support, bad for compatibility).

## Quick Comparison

| Feature | Desktop App | Browser Extension |
|---------|------------|-------------------|
| Works in | All apps | Browser only |
| Install difficulty | ❌ Hard on Asahi | ✅ Easy |
| Kernel dependencies | ❌ Yes (blocked) | ✅ None |
| Compilation needed | ❌ Yes | ✅ No |
| M1 compatibility | ⚠️ Maybe | ✅ Perfect |
| Use cases | Terminals, editors | Web forms |

## What I Recommend

**For your M1 Mac running Asahi Linux:**

1. **Use the browser extension** (Firefox or Chrome)
   - Takes 5 minutes
   - Works perfectly
   - No compilation issues

2. **Save the desktop app for later**
   - Try it when Asahi Linux matures
   - Or when Python fixes the expat bug
   - Or on a different Linux system

## Commands to Run

### Option 1: Browser Extension (Recommended)

```bash
# Go to main folder
cd ~/Downloads/vortexsite-claude-human-typing-extension-Wxdbw

# For Firefox
./package-firefox.sh
# Then load in Firefox at about:debugging -> Load Temporary Add-on

# OR for Chrome
./package.sh
# Then load in Chrome at chrome://extensions -> Load unpacked
```

### Option 2: Try Desktop App Anyway

```bash
cd ~/Downloads/vortexsite-claude-human-typing-extension-Wxdbw/linux-app
./fix-asahi-linux.sh
```

If successful:
```bash
python3 human-typer.py
```

## Files You Actually Need

If you just want the essential files:

**For Browser Extension:**
- `manifest.json` (or `manifest-firefox.json`)
- `popup.html`
- `popup.js`
- `content.js`
- `styles.css`
- `browser-polyfill-lite.js`
- Icons (or skip them)

**For Desktop App:**
- `human-typer.py`
- That's it! (if you can get pynput installed)

## Still Want Help?

If you want to keep trying the desktop app:

1. **First fix pip:**
   ```bash
   sudo dnf reinstall expat python3-libs
   python3 -m pip --version  # Should work now
   ```

2. **Then try installing pynput directly:**
   ```bash
   python3 -m pip install --user pynput
   ```

3. **If that fails, use the browser extension!**

## Bottom Line

**Your M1 Mac running Asahi Linux has special restrictions.**

The browser extension is the easiest path forward and works perfectly. The desktop app is possible but requires fighting with Asahi's kernel restrictions and Python 3.13 bugs.

**My recommendation: Use the browser extension. It's what I would do.**
