#!/bin/bash

# Package script for Human Typer Firefox Add-on

echo "📦 Packaging Human Typer for Firefox Add-ons..."
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
    echo "Alternatively, you can proceed without icons (Firefox will use defaults)."
    read -p "Continue without icons? (y/n): " continue_without_icons

    if [ "$continue_without_icons" != "y" ]; then
        echo "Cancelled."
        exit 1
    fi

    # Create dummy manifest without icons for testing
    FILES="manifest-firefox.json popup.html popup.js content.js styles.css browser-polyfill-lite.js"
    echo ""
    echo "⚠️  Creating package without icons..."
else
    FILES="manifest-firefox.json popup.html popup.js content.js styles.css browser-polyfill-lite.js icon16.png icon48.png icon128.png"
    echo "✅ All icon files found!"
fi

echo ""
echo "Creating Firefox package..."

# Remove old package if exists
rm -f human-typer-firefox.zip

# Create temporary directory
TEMP_DIR=$(mktemp -d)
echo "Using temp directory: $TEMP_DIR"

# Copy files to temp directory
for file in $FILES; do
    if [ -f "$file" ]; then
        cp "$file" "$TEMP_DIR/"
    else
        echo "⚠️  Warning: $file not found, skipping..."
    fi
done

# Rename manifest-firefox.json to manifest.json in temp directory
if [ -f "$TEMP_DIR/manifest-firefox.json" ]; then
    mv "$TEMP_DIR/manifest-firefox.json" "$TEMP_DIR/manifest.json"
fi

# Create ZIP from temp directory
cd "$TEMP_DIR"
zip -r human-typer-firefox.zip *
cd - > /dev/null

# Move ZIP to current directory
mv "$TEMP_DIR/human-typer-firefox.zip" ./

# Clean up temp directory
rm -rf "$TEMP_DIR"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Firefox package created successfully: human-typer-firefox.zip"
    echo ""
    echo "Next steps:"
    echo "1. Go to: https://addons.mozilla.org/developers/"
    echo "2. Click 'Submit a New Add-on'"
    echo "3. Upload human-typer-firefox.zip"
    echo "4. Fill out the listing information"
    echo "5. Submit for review"
    echo ""
    echo "OR install temporarily for testing:"
    echo "1. Go to: about:debugging#/runtime/this-firefox"
    echo "2. Click 'Load Temporary Add-on...'"
    echo "3. Select human-typer-firefox.zip"
    echo ""
    echo "File size: $(ls -lh human-typer-firefox.zip | awk '{print $5}')"
    echo ""
else
    echo "❌ Error creating package!"
    exit 1
fi
