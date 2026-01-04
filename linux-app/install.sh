#!/bin/bash

# Installation script for Human Typer Desktop App
# Works on Ubuntu, Debian, Fedora, Arch, and other Linux distributions

echo "========================================="
echo "  Human Typer Desktop - Installation"
echo "========================================="
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo "⚠️  Please do not run this script as root/sudo"
    echo "The script will ask for sudo when needed"
    exit 1
fi

# Detect distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "❌ Could not detect Linux distribution"
    exit 1
fi

echo "📦 Detected distribution: $DISTRO"
echo ""

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed"
    echo "Please install Python 3 first:"
    case $DISTRO in
        ubuntu|debian)
            echo "  sudo apt install python3 python3-pip python3-tk"
            ;;
        fedora)
            echo "  sudo dnf install python3 python3-pip python3-tkinter"
            ;;
        arch|manjaro)
            echo "  sudo pacman -S python python-pip tk"
            ;;
        *)
            echo "  Install python3, pip, and tkinter for your distribution"
            ;;
    esac
    exit 1
fi

echo "✅ Python 3 found: $(python3 --version)"

# Check if pip is installed
if ! command -v pip3 &> /dev/null; then
    echo "⚠️  pip3 not found, installing..."
    case $DISTRO in
        ubuntu|debian)
            sudo apt install -y python3-pip
            ;;
        fedora)
            sudo dnf install -y python3-pip
            ;;
        arch|manjaro)
            sudo pacman -S --noconfirm python-pip
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
else
    echo "✅ tkinter is installed"
fi

# Install Python dependencies
echo ""
echo "📥 Installing Python dependencies..."
pip3 install --user -r requirements.txt

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo "✅ Dependencies installed"

# Make script executable
chmod +x human-typer.py

# Create desktop entry
echo ""
echo "🖥️  Creating desktop entry..."

INSTALL_DIR="$(pwd)"
DESKTOP_FILE="$HOME/.local/share/applications/human-typer.desktop"

mkdir -p "$HOME/.local/share/applications"

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

# Update desktop database
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$HOME/.local/share/applications" 2>/dev/null
fi

echo "✅ Desktop entry created"

# Create launcher script in ~/bin (if it exists in PATH)
if [ -d "$HOME/bin" ] && [[ ":$PATH:" == *":$HOME/bin:"* ]]; then
    echo ""
    echo "🔗 Creating launcher in ~/bin..."
    cat > "$HOME/bin/human-typer" << EOF
#!/bin/bash
python3 "$INSTALL_DIR/human-typer.py"
EOF
    chmod +x "$HOME/bin/human-typer"
    echo "✅ Launcher created. You can now run 'human-typer' from anywhere!"
fi

echo ""
echo "========================================="
echo "  ✅ Installation Complete!"
echo "========================================="
echo ""
echo "How to run:"
echo "1. From applications menu: Search for 'Human Typer'"
echo "2. From terminal: python3 $INSTALL_DIR/human-typer.py"
if [ -f "$HOME/bin/human-typer" ]; then
    echo "3. From terminal: human-typer"
fi
echo ""
echo "📖 See README.md for usage instructions"
echo ""
