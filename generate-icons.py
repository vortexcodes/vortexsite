#!/usr/bin/env python3
"""
Generate icon files for Human Typer Chrome Extension
Creates 16x16, 48x48, and 128x128 PNG icons
"""

try:
    from PIL import Image, ImageDraw, ImageFont
    PIL_AVAILABLE = True
except ImportError:
    PIL_AVAILABLE = False
    print("PIL not available, creating minimal icons...")

import base64
import io

def create_simple_icon(size):
    """Create a simple gradient icon with 'HT' text"""
    if PIL_AVAILABLE:
        # Create image with gradient background
        img = Image.new('RGB', (size, size))
        draw = ImageDraw.Draw(img)

        # Create purple gradient background
        for y in range(size):
            # Gradient from #667eea to #764ba2
            r = int(102 + (118 - 102) * (y / size))
            g = int(126 + (75 - 126) * (y / size))
            b = int(234 + (162 - 234) * (y / size))
            draw.rectangle([(0, y), (size, y+1)], fill=(r, g, b))

        # Add text
        text = "HT"
        font_size = int(size * 0.4)

        try:
            # Try to use a nice font
            font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", font_size)
        except:
            try:
                font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", font_size)
            except:
                # Fallback to default font
                font = ImageFont.load_default()

        # Calculate text position (centered)
        bbox = draw.textbbox((0, 0), text, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]

        x = (size - text_width) // 2
        y = (size - text_height) // 2 - bbox[1]

        # Draw text with shadow for depth
        draw.text((x+1, y+1), text, fill=(0, 0, 0, 50), font=font)
        draw.text((x, y), text, fill=(255, 255, 255), font=font)

        return img
    else:
        # Create minimal colored square if PIL not available
        # This is a 1x1 purple pixel that we'll save
        # The browser will scale it
        return create_minimal_png(size)

def create_minimal_png(size):
    """Create a minimal PNG file - solid purple square"""
    img = Image.new('RGB', (size, size), color=(102, 126, 234))
    return img

def main():
    sizes = [16, 48, 128]

    print("Generating Human Typer extension icons...")
    print(f"PIL available: {PIL_AVAILABLE}")
    print()

    for size in sizes:
        filename = f"icon{size}.png"
        print(f"Creating {filename}...")

        img = create_simple_icon(size)
        img.save(filename, "PNG")

        print(f"  ✓ {filename} created ({size}x{size})")

    print()
    print("✅ All icons created successfully!")
    print()
    print("Next steps:")
    print("1. Run ./package.sh to create the ZIP file")
    print("2. Upload to Chrome Web Store")

if __name__ == "__main__":
    if not PIL_AVAILABLE:
        print("⚠️  Warning: Pillow (PIL) not installed.")
        print("Installing Pillow for better icons...")
        import subprocess
        try:
            subprocess.check_call(["pip3", "install", "Pillow"])
            print("✓ Pillow installed! Re-running script...")
            # Re-import PIL
            from PIL import Image, ImageDraw, ImageFont
            PIL_AVAILABLE = True
        except:
            print("Could not install Pillow. Creating basic icons instead.")

    main()
