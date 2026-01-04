#!/bin/bash

# Fix for Asahi Linux (Fedora on M1/M2 Mac)
# Addresses broken Python 3.13 and Asahi kernel restrictions

echo "========================================="
echo "  Asahi Linux Fix for Human Typer"
echo "========================================="
echo ""

echo "Detected: Asahi Linux on M1/M2 Mac"
echo ""

# Step 1: Fix broken Python/pip
echo "🔧 Step 1: Fixing broken Python installation..."
echo "Reinstalling expat library..."
sudo dnf reinstall -y expat python3-libs

echo ""
echo "Testing if pip works now..."
if python3 -m pip --version 2>/dev/null; then
    echo "✅ pip is working!"
else
    echo "⚠️  pip still broken, trying alternative fix..."
    sudo dnf reinstall -y python3 python3-pip
fi

echo ""
echo "🔧 Step 2: Installing dependencies without kernel-devel..."
echo "(Asahi Linux doesn't allow kernel-devel due to custom kernel)"

# Install everything we can
sudo dnf install -y \
    python3-tkinter \
    libX11-devel \
    libXtst-devel \
    libxcb \
    python3-xlib

echo ""
echo "🔧 Step 3: Trying to install pynput with pip..."

# Try using pip with python -m pip (more reliable)
python3 -m pip install --user pynput 2>&1 | tee /tmp/pynput-install.log

if [ ${PIPESTATUS[0]} -eq 0 ]; then
    echo "✅ pynput installed successfully!"
else
    echo "⚠️  pip install failed, trying DNF package manager..."

    # Try to install from Fedora repos
    sudo dnf install -y python3-pynput 2>/dev/null

    if [ $? -eq 0 ]; then
        echo "✅ Installed pynput from system packages!"
    else
        echo ""
        echo "❌ Could not install pynput automatically."
        echo ""
        echo "========================================="
        echo "  Alternative Solution"
        echo "========================================="
        echo ""
        echo "Since pynput won't install on Asahi Linux due to"
        echo "kernel restrictions, you have two options:"
        echo ""
        echo "OPTION 1: Use the Browser Extension instead"
        echo "  - Works in Firefox/Chrome"
        echo "  - No kernel dependencies needed"
        echo "  - See ../FIREFOX.md or ../README.md"
        echo ""
        echo "OPTION 2: Manual pynput build (advanced)"
        echo "  1. Download pynput source:"
        echo "     wget https://files.pythonhosted.org/packages/source/p/pynput/pynput-1.7.6.tar.gz"
        echo "  2. Extract and modify to skip evdev"
        echo "  3. Install manually"
        echo ""
        echo "Recommendation: Use the browser extension!"
        echo "It's easier and works great on M1 Macs."
        exit 1
    fi
fi

echo ""
echo "🧪 Testing installation..."
if python3 -c "from pynput.keyboard import Controller; print('✅ pynput works!')" 2>/dev/null; then
    echo ""
    echo "========================================="
    echo "  ✅ Installation Successful!"
    echo "========================================="
    echo ""
    echo "Run the app:"
    echo "  python3 human-typer.py"
    echo ""
else
    echo ""
    echo "⚠️  pynput installed but may not work properly."
    echo "This is common on Asahi Linux."
    echo ""
    echo "Try running the app anyway:"
    echo "  python3 human-typer.py"
    echo ""
    echo "If it doesn't work, use the browser extension instead."
    echo "See ../FIREFOX.md for Firefox installation."
fi
