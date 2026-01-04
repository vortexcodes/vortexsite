#!/bin/bash

# Quick run script - runs Human Typer without full installation
# Installs all required dependencies and runs the app

echo "========================================="
echo "  Human Typer - Quick Start"
echo "========================================="
echo ""

# Detect distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    DISTRO="unknown"
fi

echo "📦 Detected: $DISTRO on $(uname -m)"
echo ""

# Check Python 3
echo "🔍 Checking Python 3..."
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 not found"
    echo "Installing Python 3..."

    case $DISTRO in
        ubuntu|debian)
            sudo apt update && sudo apt install -y python3 python3-pip
            ;;
        fedora)
            sudo dnf install -y python3 python3-pip
            ;;
        arch|manjaro)
            sudo pacman -S --noconfirm python python-pip
            ;;
        *)
            echo "Please install Python 3 for your distribution"
            exit 1
            ;;
    esac
fi

echo "✅ Python 3: $(python3 --version)"

# Check tkinter
echo ""
echo "🔍 Checking tkinter (GUI)..."
if ! python3 -c "import tkinter" 2>/dev/null; then
    echo "⚠️  tkinter not found, installing..."

    case $DISTRO in
        ubuntu|debian)
            sudo apt install -y python3-tk
            ;;
        fedora)
            sudo dnf install -y python3-tkinter
            ;;
        arch|manjaro)
            sudo pacman -S --noconfirm tk
            ;;
        *)
            echo "Please install python3-tkinter for your distribution"
            exit 1
            ;;
    esac

    if ! python3 -c "import tkinter" 2>/dev/null; then
        echo "❌ Failed to install tkinter"
        exit 1
    fi
fi

echo "✅ tkinter is installed"

# Install X11 libraries
echo ""
echo "🔍 Installing X11 libraries (for keyboard control)..."

case $DISTRO in
    ubuntu|debian)
        sudo apt install -y libx11-dev libxtst-dev libxcb1 python3-xlib x11-utils 2>/dev/null
        ;;
    fedora)
        sudo dnf install -y libX11-devel libXtst-devel libxcb python3-xlib xorg-x11-utils 2>/dev/null
        ;;
    arch|manjaro)
        sudo pacman -S --noconfirm libx11 libxtst libxcb python-xlib xorg-xev 2>/dev/null
        ;;
esac

echo "✅ X11 libraries installed"

# Check/install pynput
echo ""
echo "🔍 Checking pynput (keyboard library)..."
if ! python3 -c "import pynput" 2>/dev/null; then
    echo "⚠️  pynput not found, installing..."
    pip3 install --user pynput

    if [ $? -ne 0 ]; then
        echo "❌ Failed to install pynput"
        echo ""
        echo "Please try manually:"
        echo "  pip3 install --user pynput"
        exit 1
    fi
fi

echo "✅ pynput is installed"

# Make executable
chmod +x human-typer.py 2>/dev/null

# Run the app
echo ""
echo "========================================="
echo "  ✅ All Dependencies Installed!"
echo "========================================="
echo ""
echo "🚀 Starting Human Typer..."
echo ""

python3 human-typer.py
