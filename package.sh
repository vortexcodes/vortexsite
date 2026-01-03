#!/bin/bash

# Package script for Human Typer Chrome Extension

echo "📦 Packaging Human Typer for Chrome Web Store..."
echo ""

# Check if icons exist
if [ ! -f "icon16.png" ] || [ ! -f "icon48.png" ] || [ ! -f "icon128.png" ]; then
    echo "⚠️  WARNING: Icon files not found!"
    echo ""
    echo "Please create icon files first:"
    echo "1. Open create-icons.html in your browser"
    echo "2. Download all three icon sizes"
    echo "3. Place them in this directory"
    echo "4. Run this script again"
    echo ""
    echo "Alternatively, you can proceed without icons (Chrome will use defaults)."
    read -p "Continue without icons? (y/n): " continue_without_icons

    if [ "$continue_without_icons" != "y" ]; then
        echo "Cancelled."
        exit 1
    fi

    # Create dummy manifest without icons for testing
    FILES="manifest.json popup.html popup.js content.js styles.css browser-polyfill-lite.js"
    echo ""
    echo "⚠️  Creating package without icons..."
else
    FILES="manifest.json popup.html popup.js content.js styles.css browser-polyfill-lite.js icon16.png icon48.png icon128.png"
    echo "✅ All icon files found!"
fi

echo ""
echo "Creating ZIP package..."

# Remove old package if exists
rm -f human-typer.zip

# Create new package
zip -r human-typer.zip $FILES

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Package created successfully: human-typer.zip"
    echo ""
    echo "Next steps:"
    echo "1. Go to: https://chrome.google.com/webstore/devconsole/"
    echo "2. Click 'New Item'"
    echo "3. Upload human-typer.zip"
    echo "4. Fill out the store listing (see PUBLISHING.md for details)"
    echo "5. Submit for review"
    echo ""
    echo "File size: $(ls -lh human-typer.zip | awk '{print $5}')"
    echo ""
else
    echo "❌ Error creating package!"
    exit 1
fi
