#!/bin/bash

# Simple installation for M1 Mac running Fedora
# Fixes the evdev/pynput compilation error

echo "========================================="
echo "  Installing Human Typer for M1 Fedora"
echo "========================================="
echo ""

echo "📦 Step 1: Installing kernel headers (needed for pynput)..."
sudo dnf install -y kernel-headers kernel-devel

echo ""
echo "📦 Step 2: Installing Python and GUI libraries..."
sudo dnf install -y python3 python3-pip python3-tkinter

echo ""
echo "📦 Step 3: Installing X11 libraries..."
sudo dnf install -y libX11-devel libXtst-devel libxcb python3-xlib

echo ""
echo "📦 Step 4: Installing pynput (keyboard control)..."
pip3 install --user pynput

if [ $? -ne 0 ]; then
    echo ""
    echo "⚠️  pynput installation failed. Trying with system compiler..."
    sudo dnf install -y gcc python3-devel
    pip3 install --user pynput
fi

echo ""
echo "📦 Step 5: Verifying installation..."
python3 -c "from pynput.keyboard import Controller; print('✅ pynput working!')" 2>&1

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================="
    echo "  ✅ Installation Complete!"
    echo "========================================="
    echo ""
    echo "Run the app with:"
    echo "  python3 human-typer.py"
    echo ""
else
    echo ""
    echo "❌ Installation failed. See error above."
    echo ""
    echo "Try installing manually:"
    echo "  sudo dnf install kernel-headers kernel-devel gcc python3-devel"
    echo "  pip3 install --user pynput"
fi
