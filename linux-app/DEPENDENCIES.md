# Complete Dependency List

This document lists ALL programs and packages required to run Human Typer on Linux.

## Core Requirements

### 1. Python 3.6 or Higher

**What it is:** Programming language runtime
**Why needed:** The app is written in Python

**Installation:**

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install -y python3 python3-pip
```

**Fedora:**
```bash
sudo dnf install -y python3 python3-pip
```

**Arch Linux:**
```bash
sudo pacman -S python python-pip
```

**Verify:**
```bash
python3 --version  # Should show 3.6 or higher
pip3 --version     # Should show pip version
```

---

### 2. Tkinter (Python GUI Library)

**What it is:** Python's standard GUI framework
**Why needed:** Creates the graphical user interface

**Installation:**

**Ubuntu/Debian:**
```bash
sudo apt install -y python3-tk
```

**Fedora:**
```bash
sudo dnf install -y python3-tkinter
```

**Arch Linux:**
```bash
sudo pacman -S tk
```

**Verify:**
```bash
python3 -c "import tkinter; print('tkinter OK')"
```

---

### 3. X11 Libraries (Display Server)

**What it is:** X Window System libraries for keyboard/mouse control
**Why needed:** pynput uses these to simulate keyboard input

#### libx11 (X11 client library)

**Ubuntu/Debian:**
```bash
sudo apt install -y libx11-dev
```

**Fedora:**
```bash
sudo dnf install -y libX11-devel
```

**Arch Linux:**
```bash
sudo pacman -S libx11
```

#### libxtst (X11 XTEST extension)

**Ubuntu/Debian:**
```bash
sudo apt install -y libxtst-dev
```

**Fedora:**
```bash
sudo dnf install -y libXtst-devel
```

**Arch Linux:**
```bash
sudo pacman -S libxtst
```

#### libxcb (X protocol C-language Binding)

**Ubuntu/Debian:**
```bash
sudo apt install -y libxcb1
```

**Fedora:**
```bash
sudo dnf install -y libxcb
```

**Arch Linux:**
```bash
sudo pacman -S libxcb
```

#### python-xlib (Python X11 library)

**Ubuntu/Debian:**
```bash
sudo apt install -y python3-xlib
```

**Fedora:**
```bash
sudo dnf install -y python3-xlib
```

**Arch Linux:**
```bash
sudo pacman -S python-xlib
```

---

### 4. X11 Utilities (Optional but Recommended)

**What it is:** Tools for testing X11 functionality
**Why needed:** Helps troubleshoot keyboard/mouse issues

**Ubuntu/Debian:**
```bash
sudo apt install -y x11-utils
```

**Fedora:**
```bash
sudo dnf install -y xorg-x11-utils
```

**Arch Linux:**
```bash
sudo pacman -S xorg-xev
```

**Test with:**
```bash
xev  # Opens event tester - press keys to see if X11 detects them
```

---

### 5. pynput (Python Keyboard Library)

**What it is:** Python library for controlling keyboard/mouse
**Why needed:** Core functionality for typing simulation

**Installation:**
```bash
pip3 install --user pynput
```

**Verify:**
```bash
python3 -c "from pynput.keyboard import Controller; print('pynput OK')"
```

---

## Complete One-Command Installation

### Ubuntu/Debian (All at Once)

```bash
sudo apt update && sudo apt install -y \
    python3 \
    python3-pip \
    python3-tk \
    libx11-dev \
    libxtst-dev \
    libxcb1 \
    python3-xlib \
    x11-utils

pip3 install --user pynput
```

### Fedora (All at Once)

```bash
sudo dnf install -y \
    python3 \
    python3-pip \
    python3-tkinter \
    libX11-devel \
    libXtst-devel \
    libxcb \
    python3-xlib \
    xorg-x11-utils

pip3 install --user pynput
```

### Arch Linux (All at Once)

```bash
sudo pacman -S --noconfirm \
    python \
    python-pip \
    tk \
    libx11 \
    libxtst \
    libxcb \
    python-xlib \
    xorg-xev

pip3 install --user pynput
```

---

## Verification Checklist

After installation, run these commands to verify everything is installed:

```bash
# 1. Python
python3 --version
# Expected: Python 3.6.0 or higher

# 2. pip
pip3 --version
# Expected: pip 20.0 or higher

# 3. tkinter
python3 -c "import tkinter; print('✅ tkinter OK')"
# Expected: ✅ tkinter OK

# 4. pynput
python3 -c "from pynput.keyboard import Controller; print('✅ pynput OK')"
# Expected: ✅ pynput OK

# 5. X11 (optional test)
xev
# Expected: Opens a window that shows keyboard/mouse events
```

---

## Package Size Information

Approximate disk space required:

- **Python 3**: ~100 MB
- **pip**: ~10 MB
- **tkinter**: ~5 MB
- **X11 libraries**: ~20 MB total
- **pynput**: ~1 MB

**Total**: ~136 MB (may vary by distribution)

---

## Alternative: Minimal Installation

If you only want to test without installing system packages:

```bash
# Only install pynput (requires X11 to already be installed)
pip3 install --user pynput

# Run directly
python3 human-typer.py
```

**Note:** This only works if your system already has Python, tkinter, and X11 libraries (most desktop Linux systems do).

---

## Troubleshooting Dependencies

### Error: "tkinter module not found"

**Solution:**
```bash
# Ubuntu/Debian
sudo apt install python3-tk

# Fedora
sudo dnf install python3-tkinter

# Arch
sudo pacman -S tk
```

### Error: "pynput installation failed"

**Possible causes:**
1. pip not installed
2. X11 libraries missing

**Solution:**
```bash
# Install pip
sudo dnf install python3-pip  # Fedora
sudo apt install python3-pip  # Ubuntu

# Install X11 libraries (see section 3 above)

# Try installing again
pip3 install --user pynput
```

### Error: "Failed building wheel for pynput"

**Solution:** Install X11 development headers first:

```bash
# Fedora
sudo dnf install libX11-devel libXtst-devel

# Ubuntu/Debian
sudo apt install libx11-dev libxtst-dev
```

### Error: "Could not import pynput.keyboard"

**Possible causes:**
1. Running on Wayland instead of X11
2. Missing X11 libraries

**Solution:**

Check session type:
```bash
echo $XDG_SESSION_TYPE
```

If it says "wayland":
- Log out
- At login screen, click settings icon
- Select "GNOME on Xorg" or "KDE Plasma (X11)"
- Log back in

---

## For Specific Systems

### M1/M2 Mac Running Fedora

All packages support ARM64 architecture. No special steps needed - just use the Fedora commands above.

### Raspberry Pi (Raspberry Pi OS/Debian)

Use Ubuntu/Debian commands. All packages available for ARM.

### WSL (Windows Subsystem for Linux)

WSL2 with WSLg (Windows 11) supports X11 applications. Install as normal.

For WSL1, you need an X server like VcXsrv installed on Windows.

---

## Without Root/Sudo Access

If you don't have root access:

1. **Python/tkinter** - Ask system admin to install
2. **pynput** - Can install with `pip3 install --user pynput`
3. **X11 libraries** - Usually already installed on desktop systems

Minimal working setup:
```bash
pip3 install --user pynput
python3 human-typer.py
```

---

## Next Steps

After installing dependencies:

1. **Run the installer:**
   ```bash
   ./install.sh
   ```

2. **Or run directly:**
   ```bash
   ./run.sh
   ```

3. **Or manual run:**
   ```bash
   python3 human-typer.py
   ```

---

## Questions?

See the main [README.md](README.md) for usage instructions and troubleshooting.
