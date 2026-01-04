# Human Typer - Linux Desktop Application

A standalone desktop application for Linux that simulates realistic human typing **system-wide** in any application - web browsers, text editors, terminals, IDEs, and more!

## Features

- **System-Wide Typing**: Works in ANY application on your Linux system
- **Human-like Speed**: Variable typing speeds (60-120 WPM)
- **Realistic Typos**: Keyboard proximity-based errors with auto-correction
- **Text Humanization**: Converts formal text to casual language
- **Adjustable Settings**: Control speed, typo frequency, and delay
- **Simple GUI**: Easy-to-use graphical interface built with Tkinter
- **Lightweight**: Minimal dependencies, runs on any Linux distribution

## System Requirements

- **Linux** (Ubuntu, Debian, Fedora, Arch, or any major distribution)
- **Python 3.6+**
- **Tkinter** (usually comes with Python)
- **X11 or Wayland** display server

**Tested on:**
- Ubuntu 20.04+
- Debian 11+
- Fedora 35+
- Arch Linux
- Linux Mint
- Pop!_OS
- M1/M2 Mac running Fedora/Asahi Linux

## Required Programs & Packages

The app needs several programs installed. The installer handles this automatically, but if you want to install manually:

### Quick Install All Dependencies

**Ubuntu/Debian:**
```bash
sudo apt update && sudo apt install -y \
    python3 python3-pip python3-tk \
    libx11-dev libxtst-dev libxcb1 python3-xlib x11-utils
pip3 install --user pynput
```

**Fedora:**
```bash
sudo dnf install -y \
    python3 python3-pip python3-tkinter \
    libX11-devel libXtst-devel libxcb python3-xlib xorg-x11-utils
pip3 install --user pynput
```

**Arch Linux:**
```bash
sudo pacman -S --noconfirm \
    python python-pip tk \
    libx11 libxtst libxcb python-xlib xorg-xev
pip3 install --user pynput
```

### What Each Package Does

| Package | Purpose |
|---------|---------|
| **python3** | Programming language runtime |
| **python3-pip** | Python package installer |
| **python3-tk/tkinter** | GUI framework for the interface |
| **libx11-dev/libX11-devel** | X11 development libraries |
| **libxtst-dev/libXtst-devel** | X11 keyboard/mouse extension |
| **libxcb** | X protocol library |
| **python3-xlib** | Python X11 bindings |
| **x11-utils/xorg-x11-utils** | X11 testing tools |
| **pynput** | Python keyboard control library |

**📖 For detailed information about each dependency, see [DEPENDENCIES.md](DEPENDENCIES.md)**

## Installation

### Quick Install (Recommended)

```bash
cd linux-app
./install.sh
```

The installation script will:
1. Check for Python 3 and dependencies
2. Install required packages (`pynput`)
3. Create a desktop entry
4. Set up launcher scripts

### Manual Installation

If you prefer to install manually:

1. **Install Python and dependencies:**

   **Ubuntu/Debian:**
   ```bash
   sudo apt install python3 python3-pip python3-tk
   ```

   **Fedora:**
   ```bash
   sudo dnf install python3 python3-pip python3-tkinter
   ```

   **Arch Linux:**
   ```bash
   sudo pacman -S python python-pip tk
   ```

2. **Install Python packages:**
   ```bash
   pip3 install --user -r requirements.txt
   ```

3. **Make executable:**
   ```bash
   chmod +x human-typer.py
   ```

4. **Run:**
   ```bash
   ./human-typer.py
   ```

## Usage

### Launching the Application

**Method 1: From Applications Menu**
- Search for "Human Typer" in your application launcher
- Click to open

**Method 2: From Terminal**
```bash
python3 human-typer.py
```

**Method 3: Using Launcher (if installed)**
```bash
human-typer
```

### How to Use

1. **Launch the application**

2. **Enter your text:**
   - Paste or type text in the text area
   - You can use the placeholder text or replace it with your own

3. **Configure settings:**
   - **Humanize Text**: Check to make text sound more natural/casual
   - **Enable Random Typos**: Check to add realistic typing mistakes
   - **Typing Speed**: Choose slow (60-80 WPM), normal (80-100 WPM), or fast (100-120 WPM)
   - **Typo Frequency**: Adjust slider (0-10%)
   - **Delay**: Set countdown time before typing starts (default: 3 seconds)

4. **Click "Start Typing"**
   - A countdown will begin
   - During the countdown, click on ANY text field in ANY application
   - This could be:
     - Web browser form
     - Text editor (gedit, kate, nano, vim, emacs)
     - Terminal
     - IDE (VS Code, PyCharm, etc.)
     - Office application (LibreOffice, Google Docs in browser)
     - Messaging app (Slack, Discord in browser)
     - Literally ANY application that accepts text input

5. **Watch it type!**
   - The text will appear as if typed by a human
   - Progress bar shows completion status
   - Click "Stop" to interrupt at any time

### Example Use Cases

**Testing web forms:**
```
1. Open browser to form
2. Enter test data in Human Typer
3. Click Start Typing
4. Click on first form field
5. Watch form fill automatically with realistic typing
```

**Writing code/text:**
```
1. Open VS Code / text editor
2. Paste code/text into Human Typer
3. Click Start Typing
4. Click in editor
5. Code appears with natural typing patterns
```

**Demonstrations:**
```
1. Prepare presentation text
2. Enable humanization and typos
3. Type live during demo for realistic effect
```

## Settings Explained

### Typing Speed

- **Slow (60-80 WPM)**: Beginner typing speed
- **Normal (80-100 WPM)**: Average typing speed (recommended)
- **Fast (100-120 WPM)**: Professional typing speed

Each keystroke has random variation to mimic real human typing.

### Typo Frequency

- **0%**: No typos (perfect typing)
- **1-3%**: Occasional mistakes (recommended for realism)
- **4-7%**: Frequent mistakes
- **8-10%**: Very error-prone typing

Typos are based on keyboard proximity (e.g., 'a' might become 's' or 'q'). The application will:
1. Type the wrong character
2. Pause (realizing the mistake)
3. Press backspace
4. Type the correct character

### Humanize Text

Converts formal language to casual:
- "I am" → "I'm"
- "do not" → "don't"
- "However" → "but"
- "furthermore" → "plus"
- Adds occasional filler words ("So,", "Well,", "Actually,")

Perfect for making automated responses sound more natural.

### Delay Before Typing

- **0 seconds**: Starts typing immediately (must have field focused first)
- **3 seconds**: Default - gives you time to switch to target application
- **5-10 seconds**: Useful if you need time to navigate to the right field

## Troubleshooting

### Application won't start

**Error: `tkinter` module not found**
```bash
# Ubuntu/Debian
sudo apt install python3-tk

# Fedora
sudo dnf install python3-tkinter

# Arch
sudo pacman -S tk
```

**Error: `pynput` module not found**
```bash
pip3 install --user pynput
```

### Typing doesn't work

**Issue: Nothing happens after clicking "Start Typing"**

1. **Check permissions**: `pynput` might need X11 access
2. **Try running from terminal** to see error messages:
   ```bash
   python3 human-typer.py
   ```
3. **Make sure you click in a text field** during the countdown

**Issue: Typing works but characters are wrong**

- **Keyboard layout**: Make sure your system keyboard layout matches
- **Special characters**: Some special characters might not work with `pynput`

### Wayland compatibility

If you're using Wayland instead of X11:

1. **Check your display server:**
   ```bash
   echo $XDG_SESSION_TYPE
   ```

2. **If Wayland**, you may need to:
   - Switch to X11 session (select at login)
   - Or install additional packages:
     ```bash
     pip3 install --user evdev
     ```
   - Or run with XWayland compatibility

**Note:** `pynput` works best with X11. For pure Wayland, consider using the browser extension instead.

### Permission errors

**Error: Permission denied**

```bash
chmod +x human-typer.py
chmod +x install.sh
```

## Uninstallation

To remove Human Typer:

```bash
# Remove desktop entry
rm ~/.local/share/applications/human-typer.desktop

# Remove launcher (if created)
rm ~/bin/human-typer

# Remove Python package
pip3 uninstall pynput

# Delete application folder
cd ..
rm -rf linux-app
```

## Development

### Project Structure

```
linux-app/
├── human-typer.py      # Main application
├── requirements.txt    # Python dependencies
├── install.sh         # Installation script
└── README.md          # This file
```

### Dependencies

- **pynput**: Keyboard input simulation
- **tkinter**: GUI (comes with Python)
- **threading**: Async typing (standard library)
- **re**: Text processing (standard library)

### Contributing

Contributions welcome! To add features:

1. Fork the repository
2. Create a feature branch
3. Make your changes to `human-typer.py`
4. Test on multiple Linux distributions
5. Submit a pull request

## Differences from Browser Extension

| Feature | Browser Extension | Desktop App |
|---------|------------------|-------------|
| **Scope** | Browser only | System-wide |
| **Applications** | Web forms, textareas | ANY application |
| **Installation** | Chrome/Firefox store | Manual install |
| **Dependencies** | None | Python, pynput |
| **Platform** | Cross-platform | Linux only |
| **Smart Replace** | ✓ | ✗ (future feature) |

## Security & Privacy

- **100% Local**: Everything runs on your computer
- **No Network**: No data sent anywhere
- **No Logging**: No keylogging or recording
- **Open Source**: Code is fully visible and auditable
- **Permissions**: Only needs ability to simulate keyboard input

**What it does:**
- Simulates keyboard input using `pynput`
- Reads text from GUI text area
- Does NOT capture your actual typing
- Does NOT send data over network

## FAQ

**Q: Will this work on Wayland?**
A: It works best on X11. For Wayland, try the browser extension or switch to X11 session.

**Q: Can I use keyboard shortcuts?**
A: Not yet, but this could be added as a feature.

**Q: Does it work in terminals?**
A: Yes! Works in gnome-terminal, konsole, xterm, etc.

**Q: Can I type passwords with this?**
A: Technically yes, but not recommended for security reasons. Use password managers instead.

**Q: Will it work with my non-English keyboard?**
A: Should work, but typo generation is optimized for QWERTY layout.

**Q: Can I run this on Windows or Mac?**
A: This version is Linux-specific. Use the browser extension for Windows/Mac.

**Q: Is it safe to use?**
A: Yes, the code is open source and does not collect or transmit any data.

## Support

For issues or questions:
1. Check the [Troubleshooting](#troubleshooting) section
2. Look for error messages in the terminal
3. Open an issue on GitHub with:
   - Linux distribution and version
   - Python version (`python3 --version`)
   - Display server (X11 or Wayland)
   - Error messages

## License

MIT License - free to use, modify, and distribute.

## Acknowledgments

- **pynput**: For keyboard input simulation
- **Python**: For the runtime
- **Tkinter**: For the GUI framework

---

**Happy typing! 🎹**
