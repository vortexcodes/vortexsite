# Extension Icons

This extension references icon files in the manifest, but they are not included in the repository.

## Creating Icons

You can create your own icons using any image editor. You'll need three sizes:

- `icon16.png` - 16x16 pixels
- `icon48.png` - 48x48 pixels
- `icon128.png` - 128x128 pixels

## Design Suggestions

For a "Human Typer" extension, consider:
- A keyboard icon
- A typing hand icon
- The letters "HT" on a colored background
- A robot/human hybrid symbol

## Quick Icon Creation

### Option 1: Use an online tool
- Visit https://www.favicon-generator.org/
- Upload a square image
- Download the generated icons
- Rename them to match the required sizes

### Option 2: Use ImageMagick (command line)
```bash
# Create a simple text-based icon
convert -size 128x128 xc:purple -pointsize 60 -fill white -gravity center -annotate +0+0 "HT" icon128.png
convert icon128.png -resize 48x48 icon48.png
convert icon128.png -resize 16x16 icon16.png
```

### Option 3: Use Canva or Figma
- Create a 128x128 square design
- Export as PNG
- Resize for other dimensions

## Without Icons

The extension will work fine without custom icons - Chrome will just display a default extension icon. This is perfectly acceptable for development and personal use.
