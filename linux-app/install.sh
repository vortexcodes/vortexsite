#!/bin/bash

# Installation script for Human Typer Desktop App
# Works on Ubuntu, Debian, Fedora, Arch, and other Linux distributions
# Compatible with x86_64 and ARM64 (M1/M2 Mac, Raspberry Pi, etc.)

echo "========================================="
echo "  Human Typer Desktop - Installation"
echo "========================================="
echo ""

# Detect architecture
ARCH=$(uname -m)
echo "🔍 Detected architecture: $ARCH"

if [[ "$ARCH" == "arm64" ]] || [[ "$ARCH" == "aarch64" ]]; then
    echo "✅ ARM64 detected (M1/M2 Mac or ARM device)"
fi

# Detect distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "❌ Could not detect Linux distribution"
    echo "Continuing with generic installation..."
    DISTRO="unknown"
fi

echo "📦 Detected distribution: $DISTRO"
echo ""

# Determine if we should use sudo
USE_SUDO=""
if [ "$EUID" -ne 0 ]; then
    # Not running as root, will need sudo for system packages
    USE_SUDO="sudo"
    echo "ℹ️  Will use sudo for system package installation"
else
    echo "ℹ️  Running as root"
fi

echo ""

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed"
    echo ""
    echo "Please install Python 3 first:"
    case $DISTRO in
        ubuntu|debian)
            echo "  $USE_SUDO apt update && $USE_SUDO apt install -y python3 python3-pip python3-tk"
            ;;
        fedora)
            echo "  $USE_SUDO dnf install -y python3 python3-pip python3-tkinter"
            ;;
        arch|manjaro)
            echo "  $USE_SUDO pacman -S --noconfirm python python-pip tk"
            ;;
        *)
            echo "  Install python3, pip, and tkinter for your distribution"
            ;;
    esac

    echo ""
    read -p "Would you like me to install Python 3 now? (y/n): " install_python

    if [ "$install_python" = "y" ]; then
        case $DISTRO in
            ubuntu|debian)
                $USE_SUDO apt update && $USE_SUDO apt install -y python3 python3-pip python3-tk
                ;;
            fedora)
                $USE_SUDO dnf install -y python3 python3-pip python3-tkinter
                ;;
            arch|manjaro)
                $USE_SUDO pacman -S --noconfirm python python-pip tk
                ;;
            *)
                echo "❌ Unsupported distribution for automatic installation"
                exit 1
                ;;
        esac

        if [ $? -ne 0 ]; then
            echo "❌ Failed to install Python 3"
            exit 1
        fi
    else
        exit 1
    fi
fi

echo "✅ Python 3 found: $(python3 --version)"

# Check if pip is installed
if ! command -v pip3 &> /dev/null; then
    echo "⚠️  pip3 not found, installing..."
    case $DISTRO in
        ubuntu|debian)
            $USE_SUDO apt install -y python3-pip
            ;;
        fedora)
            $USE_SUDO dnf install -y python3-pip
            ;;
        arch|manjaro)
            $USE_SUDO pacman -S --noconfirm python-pip
            ;;
        *)
            echo "⚠️  Could not install pip automatically"
            echo "Please install pip3 manually"
            ;;
    esac
fi

# Check if tkinter is installed
echo ""
echo "🔍 Checking for tkinter..."
if ! python3 -c "import tkinter" 2>/dev/null; then
    echo "⚠️  tkinter not found, installing..."
    case $DISTRO in
        ubuntu|debian)
            $USE_SUDO apt install -y python3-tk
            ;;
        fedora)
            $USE_SUDO dnf install -y python3-tkinter
            ;;
        arch|manjaro)
            $USE_SUDO pacman -S --noconfirm tk
            ;;
        *)
            echo "⚠️  Could not install tkinter automatically"
            echo "Please install python3-tkinter for your distribution"
            ;;
    esac

    # Check again
    if ! python3 -c "import tkinter" 2>/dev/null; then
        echo "❌ tkinter installation failed or not available"
        echo "The app requires tkinter to run the GUI"
        echo ""
        echo "You can try installing it manually:"
        echo "  - Ubuntu/Debian: $USE_SUDO apt install python3-tk"
        echo "  - Fedora: $USE_SUDO dnf install python3-tkinter"
        echo "  - Arch: $USE_SUDO pacman -S tk"
        exit 1
    fi
else
    echo "✅ tkinter is installed"
fi

# Install Python dependencies
echo ""
echo "📥 Installing Python dependencies (pynput)..."

# Try pip3 install with --user flag (doesn't need sudo)
if [ "$EUID" -ne 0 ]; then
    # Not root, use --user
    pip3 install --user -r requirements.txt
else
    # Running as root, don't use --user
    pip3 install -r requirements.txt
fi

if [ $? -ne 0 ]; then
    echo "⚠️  pip install failed, trying alternative methods..."

    # Try without requirements file
    if [ "$EUID" -ne 0 ]; then
        pip3 install --user pynput
    else
        pip3 install pynput
    fi

    if [ $? -ne 0 ]; then
        echo "❌ Failed to install dependencies"
        echo ""
        echo "Please try manually:"
        echo "  pip3 install --user pynput"
        echo ""
        echo "Or install system package:"
        case $DISTRO in
            ubuntu|debian)
                echo "  $USE_SUDO apt install python3-pynput"
                ;;
            fedora)
                echo "  $USE_SUDO dnf install python3-pynput"
                ;;
        esac
        exit 1
    fi
fi

echo "✅ Dependencies installed"

# Make script executable
chmod +x human-typer.py

# Create desktop entry (skip if running as root in container)
if [ -n "$HOME" ] && [ "$HOME" != "/root" ] || [ "$EUID" -eq 0 ]; then
    echo ""
    echo "🖥️  Creating desktop entry..."

    INSTALL_DIR="$(pwd)"

    # Use proper home directory
    if [ "$EUID" -eq 0 ] && [ -n "$SUDO_USER" ]; then
        # Running with sudo, get real user's home
        USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
    else
        USER_HOME="$HOME"
    fi

    DESKTOP_FILE="$USER_HOME/.local/share/applications/human-typer.desktop"

    mkdir -p "$USER_HOME/.local/share/applications"

    cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Human Typer
Comment=Simulate realistic human typing in any application
Exec=python3 $INSTALL_DIR/human-typer.py
Icon=input-keyboard
Terminal=false
Categories=Utility;Development;
Keywords=typing;automation;keyboard;
EOF

    # Fix ownership if we're sudo
    if [ "$EUID" -eq 0 ] && [ -n "$SUDO_USER" ]; then
        chown -R "$SUDO_USER:$SUDO_USER" "$USER_HOME/.local/share/applications"
    fi

    # Update desktop database
    if command -v update-desktop-database &> /dev/null; then
        update-desktop-database "$USER_HOME/.local/share/applications" 2>/dev/null || true
    fi

    echo "✅ Desktop entry created"
fi

# Test if pynput works
echo ""
echo "🧪 Testing pynput installation..."
if python3 -c "from pynput.keyboard import Controller; print('pynput OK')" 2>/dev/null; then
    echo "✅ pynput is working correctly"
else
    echo "⚠️  pynput test failed"
    echo "The app may not work properly"
    echo ""
    echo "This could be due to:"
    echo "  - Missing system libraries"
    echo "  - Wayland compatibility issues (try X11 session)"
    echo "  - Permission issues"
    echo ""
    echo "You can still try running the app:"
    echo "  python3 human-typer.py"
fi

echo ""
echo "========================================="
echo "  ✅ Installation Complete!"
echo "========================================="
echo ""
echo "How to run:"
echo "1. From terminal: python3 $(pwd)/human-typer.py"
if [ -f "$DESKTOP_FILE" ]; then
    echo "2. From applications menu: Search for 'Human Typer'"
fi
echo ""
echo "📖 See README.md for usage instructions"
echo ""
echo "⚠️  Note for M1/M2 Mac users:"
echo "   - Make sure you're running Linux (not macOS)"
echo "   - pynput works on both x86_64 and ARM64"
echo "   - If issues occur, check the README troubleshooting section"
echo ""
