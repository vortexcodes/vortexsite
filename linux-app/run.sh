#!/bin/bash

# Quick run script - runs Human Typer without installation
# Use this if you don't want to install or if install.sh fails

echo "🚀 Running Human Typer..."
echo ""

# Check Python 3
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 not found"
    echo "Please install it first: sudo dnf install python3"
    exit 1
fi

# Check tkinter
if ! python3 -c "import tkinter" 2>/dev/null; then
    echo "⚠️  tkinter not found"
    echo "Installing tkinter..."
    sudo dnf install -y python3-tkinter || {
        echo "❌ Failed to install tkinter"
        echo "Please install manually: sudo dnf install python3-tkinter"
        exit 1
    }
fi

# Check/install pynput
if ! python3 -c "import pynput" 2>/dev/null; then
    echo "⚠️  pynput not found"
    echo "Installing pynput..."
    pip3 install --user pynput || {
        echo "❌ Failed to install pynput"
        echo "Please install manually: pip3 install --user pynput"
        exit 1
    }
fi

# Run the app
echo "✅ Starting Human Typer..."
python3 human-typer.py
