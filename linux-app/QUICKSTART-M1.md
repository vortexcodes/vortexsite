# Quick Start Guide for M1/M2 Mac Running Fedora Linux

This guide is specifically for Apple Silicon (M1/M2/M3) Macs running Fedora Linux (Asahi Linux or other ARM distributions).

## Prerequisites

Make sure you're running **Fedora Linux on your M1 Mac**, not macOS. This app only works on Linux.

## Quick Install (Method 1)

```bash
cd linux-app

# Make the run script executable
chmod +x run.sh

# Run it (auto-installs everything)
./run.sh
```

The `run.sh` script will:
1. Check for Python 3
2. Install tkinter if missing
3. Install pynput if missing
4. Launch the app

## Manual Install (Method 2)

If the installer doesn't work:

### Step 1: Install System Dependencies

```bash
# Install Python, pip, and tkinter
sudo dnf install -y python3 python3-pip python3-tkinter

# Verify installation
python3 --version
python3 -c "import tkinter; print('tkinter OK')"
```

### Step 2: Install pynput

```bash
# Install pynput for current user
pip3 install --user pynput

# Verify installation
python3 -c "from pynput.keyboard import Controller; print('pynput OK')"
```

### Step 3: Run the App

```bash
# Make executable
chmod +x human-typer.py

# Run
python3 human-typer.py
```

## Troubleshooting

### Issue: "tkinter module not found"

**Solution:**
```bash
sudo dnf install python3-tkinter
```

### Issue: "pynput module not found"

**Solution:**
```bash
pip3 install --user pynput
```

### Issue: "Permission denied"

**Solution:**
```bash
chmod +x human-typer.py run.sh install.sh
```

### Issue: Typing doesn't work

**Possible causes:**
1. **Wayland vs X11**: pynput works better on X11
   - Check your session: `echo $XDG_SESSION_TYPE`
   - If Wayland, try logging out and selecting "GNOME on Xorg" at login

2. **Missing system libraries**:
   ```bash
   sudo dnf install libX11 libXtst
   ```

3. **SELinux blocking**:
   ```bash
   # Temporarily disable to test
   sudo setenforce 0

   # If that fixes it, create policy or disable permanently
   # (Check Fedora docs for proper SELinux configuration)
   ```

### Issue: "install.sh" exits immediately

This was a bug in the original script. It's now fixed in the updated version. If you still have the old script:

**Solution:**
```bash
# Use run.sh instead
./run.sh

# Or run directly
python3 human-typer.py
```

### Issue: App window doesn't appear

**Check if tkinter works:**
```bash
python3 -c "import tkinter; tkinter.Tk().mainloop()"
```

This should open an empty window. If it doesn't:
```bash
sudo dnf install python3-tkinter
```

## M1-Specific Notes

### Architecture
Your M1 Mac uses ARM64 architecture (`aarch64`). All Python packages should work, but:

- ✅ pynput: Full ARM64 support
- ✅ tkinter: Built-in, works on ARM64
- ✅ Python 3: Native ARM64 builds available

### Performance
The app runs natively on ARM64 - no emulation needed! It should be fast and efficient.

### Fedora Asahi Linux
If you're running Asahi Linux specifically:

```bash
# Update system first
sudo dnf update

# Install dependencies
sudo dnf install python3 python3-pip python3-tkinter

# Install pynput
pip3 install --user pynput

# Run
python3 human-typer.py
```

## Testing the Installation

After installation, test the app:

1. **Run the app:**
   ```bash
   python3 human-typer.py
   ```

2. **Enter test text:**
   - Type: "Hello from M1 Mac!"

3. **Click "Start Typing"**

4. **Click in any text field** (terminal, text editor, etc.)

5. **Watch it type!**

If this works, you're all set!

## Alternative: Use Browser Extension

If the desktop app doesn't work on your system, you can use the browser extension instead:
- Chrome/Edge: See main [README.md](../README.md)
- Firefox: See [FIREFOX.md](../FIREFOX.md)

The browser extension works on any OS (including macOS on M1) but only types in the browser.

## Getting Help

If you're still having issues:

1. **Check your environment:**
   ```bash
   echo "Architecture: $(uname -m)"
   echo "Distro: $(cat /etc/os-release | grep PRETTY_NAME)"
   echo "Python: $(python3 --version)"
   echo "Display: $XDG_SESSION_TYPE"
   ```

2. **Test pynput manually:**
   ```bash
   python3 << 'EOF'
   from pynput.keyboard import Controller
   import time

   kb = Controller()
   print("Will type 'test' in 3 seconds...")
   time.sleep(3)
   kb.type('test')
   print("Done!")
   EOF
   ```

3. **Run with debug output:**
   ```bash
   python3 -u human-typer.py 2>&1 | tee debug.log
   ```

4. **Open an issue** with:
   - Your architecture (from step 1)
   - Error messages
   - Debug log

## Quick Reference

```bash
# One-command install and run
cd linux-app && chmod +x run.sh && ./run.sh

# Manual run (no install)
python3 human-typer.py

# Check if everything is installed
python3 -c "import tkinter, pynput; print('All good!')"

# Reinstall pynput if needed
pip3 install --user --force-reinstall pynput
```

Good luck! The app should work great on your M1 Mac running Fedora. 🚀
