# Quick Setup for M1 Mac Running Fedora

You're getting an error because `pynput` needs Linux kernel headers to compile. Here's the simple fix:

## Exact Files You Need

You only need **2 files** from this repository:

1. **human-typer.py** - The main application
2. **requirements.txt** - Lists the pynput dependency

## Quick Fix (One Command)

Run this in the `linux-app` folder:

```bash
./install-m1-fedora.sh
```

This script installs everything you need automatically.

## Or Install Manually

If the script doesn't work, run these commands one by one:

### Step 1: Install Kernel Headers (This fixes the error)

```bash
sudo dnf install -y kernel-headers kernel-devel
```

This is what was missing! The error `linux/input.h: No such file or directory` means you need these headers.

### Step 2: Install Compiler (Needed to build pynput)

```bash
sudo dnf install -y gcc python3-devel
```

### Step 3: Install Python Packages

```bash
sudo dnf install -y python3 python3-pip python3-tkinter
```

### Step 4: Install X11 Libraries

```bash
sudo dnf install -y libX11-devel libXtst-devel libxcb python3-xlib
```

### Step 5: Install pynput

```bash
pip3 install --user pynput
```

Now it should work!

### Step 6: Run the App

```bash
python3 human-typer.py
```

## What Each Package Does

| Package | Why You Need It |
|---------|----------------|
| **kernel-headers** | Provides linux/input.h for evdev compilation |
| **kernel-devel** | Additional kernel development files |
| **gcc** | C compiler to build pynput's native components |
| **python3-devel** | Python development headers |
| **python3** | Python runtime |
| **python3-pip** | Package installer |
| **python3-tkinter** | GUI framework |
| **libX11-devel** | X11 development files |
| **libXtst-devel** | X11 keyboard/mouse testing |
| **pynput** | Keyboard control library |

## Just Want the App Files?

If you only want to download the minimum files:

```
linux-app/
├── human-typer.py          ← Main app (download this)
├── requirements.txt        ← Dependencies (download this)
└── install-m1-fedora.sh   ← Install script (download this)
```

You can download just these 3 files and run:

```bash
chmod +x install-m1-fedora.sh
./install-m1-fedora.sh
```

## Still Getting Errors?

If you still get the `linux/input.h` error after installing kernel-headers:

1. **Update your system first:**
   ```bash
   sudo dnf update -y
   ```

2. **Reboot:**
   ```bash
   sudo reboot
   ```

3. **Try again:**
   ```bash
   pip3 install --user pynput
   ```

## Alternative: Use Pre-built Binary

If compilation keeps failing, you can try installing evdev with a pre-built wheel:

```bash
pip3 install --user evdev-binary
pip3 install --user pynput
```

**Note:** This may not work with all kernel versions.

## Test If It's Working

After installation, test with:

```bash
python3 -c "from pynput.keyboard import Controller; print('✅ Working!')"
```

If you see `✅ Working!`, you're all set!

## Common Issues on M1 Fedora

### Issue: "kernel-headers not found"

**Solution:**
```bash
sudo dnf install -y kernel-headers-$(uname -r)
```

### Issue: "gcc: command not found"

**Solution:**
```bash
sudo dnf groupinstall "Development Tools"
```

### Issue: "Python.h not found"

**Solution:**
```bash
sudo dnf install -y python3-devel
```

## Ready to Use

Once installed, launch the app:

```bash
cd linux-app
python3 human-typer.py
```

A GUI window will open. Enter text, click "Start Typing", then click in any text field!
