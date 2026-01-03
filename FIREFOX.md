# Human Typer for Firefox

This extension is fully compatible with Firefox! It works exactly the same as the Chrome version.

## Installation Options

### Option 1: Install from Firefox Add-ons (Coming Soon)

Once published, you'll be able to install directly from addons.mozilla.org with one click.

### Option 2: Load Temporarily (Testing/Development)

Perfect for testing the extension immediately:

1. **Create the Firefox package:**
   ```bash
   ./package-firefox.sh
   ```

2. **Open Firefox and navigate to:**
   ```
   about:debugging#/runtime/this-firefox
   ```

3. **Click "Load Temporary Add-on..."**

4. **Select the file:**
   - Navigate to the extension folder
   - Select `human-typer-firefox.zip`
   - Or select any file from the extension folder (like `manifest-firefox.json`)

5. **The extension is now loaded!** (It will stay until you close Firefox)

### Option 3: Load Unpacked (Permanent)

For permanent installation during development:

1. **Open Firefox and navigate to:**
   ```
   about:config
   ```

2. **Accept the warning**

3. **Search for:**
   ```
   xpinstall.signatures.required
   ```

4. **Set it to `false`** (double-click)

5. **Create the XPI package:**
   ```bash
   ./package-firefox.sh
   ```

6. **Drag and drop** `human-typer-firefox.zip` into Firefox

7. **Click "Add"** when prompted

**Note:** This method requires disabling signature verification, which is only recommended for development.

## Publishing to Firefox Add-ons

### Prerequisites

1. **Mozilla Add-on Developer Account** (free)
   - Register at: https://addons.mozilla.org/developers/

2. **Extension Package**
   - Run `./package-firefox.sh` to create the package

### Publishing Steps

1. **Go to the Add-on Developer Hub:**
   - Visit: https://addons.mozilla.org/developers/
   - Sign in with your Mozilla account

2. **Submit New Add-on:**
   - Click "Submit a New Add-on"
   - Choose "On this site" (addons.mozilla.org)

3. **Upload Package:**
   - Upload `human-typer-firefox.zip`
   - Firefox will validate the package

4. **Fill Out Listing:**

   **Name:** Human Typer

   **Summary:**
   ```
   Simulate realistic human typing with variable speed, occasional typos, and text humanization features.
   ```

   **Description:**
   ```
   Human Typer simulates realistic human typing with variable speed, occasional typos, and text humanization features.

   ✨ KEY FEATURES:

   🎯 Human-like Typing Speed
   • Slow: 60-80 WPM (beginner)
   • Normal: 80-100 WPM (average)
   • Fast: 100-120 WPM (professional)
   • Natural variations and pauses

   ⌨️ Realistic Typos & Auto-correction
   • Generates typos based on keyboard proximity
   • Adjustable frequency (0-10%)
   • Automatically corrects mistakes like a real person

   💬 Text Humanization
   • Converts formal to casual language
   • Adds contractions (I am → I'm)
   • Includes natural filler words
   • Makes text sound more authentic

   🎯 Smart Replace
   • Detects matching highlighted text
   • Only types the new/different portions
   • Efficient for text editing workflows

   📋 HOW TO USE:

   1. Click the extension icon
   2. Paste your text
   3. Configure settings (speed, typos, humanization)
   4. Click "Start Typing"
   5. Focus any text field
   6. Watch realistic typing simulation!

   🔒 PRIVACY:
   • 100% local - no data sent anywhere
   • No tracking or analytics
   • Open source code
   • Only accesses active tab when activated

   Perfect for form testing, demonstrations, or anywhere you need natural-looking text input.
   ```

   **Categories:**
   - Developer Tools
   - Productivity

   **Support Email:** Your email

   **Homepage:** Your GitHub repo URL (optional)

   **Screenshots:**
   - Upload 1-5 screenshots (same as Chrome version)
   - Recommended size: 1280x800 or 640x400

5. **Privacy & Security:**

   **Privacy Policy:** (Optional, but recommended)
   ```
   This extension does not collect, store, or transmit any personal data.
   All typing simulation happens locally in your browser.
   The extension only accesses the active tab when you click "Start Typing".
   ```

   **Permissions Justification:**
   - `activeTab`: Required to type into text fields on the active webpage
   - `scripting`: Required to inject typing simulation into the page

6. **Version Notes:**
   ```
   Initial release. Fully compatible with Firefox 109+.
   ```

7. **Submit for Review:**
   - Click "Submit Version"
   - Review typically takes 1-3 days
   - You'll get an email when approved or if changes needed

## Differences from Chrome Version

The Firefox version is functionally identical to the Chrome version. The only differences are:

1. **Manifest file** - Uses `manifest-firefox.json` with Firefox-specific settings
2. **Browser API** - Uses both `chrome.*` and `browser.*` API for compatibility
3. **Add-on ID** - Has a unique Firefox add-on ID: `human-typer@vortexcodes.com`
4. **Minimum Version** - Requires Firefox 109+ (for Manifest V3 support)

## Browser Compatibility

**Supported Firefox Versions:**
- Firefox 109+ (desktop)
- Firefox Android 120+ (mobile)

**Why Firefox 109+?**
- Full Manifest V3 support
- Modern extension APIs
- Better performance

**For Older Firefox:**
If you need to support Firefox 108 or earlier, you would need to create a Manifest V2 version, which is not included in this package.

## Testing Checklist

Before submitting to Firefox Add-ons, test these scenarios:

- [ ] Install extension temporarily
- [ ] Test on regular text input
- [ ] Test on textarea
- [ ] Test on contentEditable div
- [ ] Test humanization feature
- [ ] Test smart replace feature
- [ ] Test typo generation
- [ ] Test stop button
- [ ] Open browser console (F12) - check for errors
- [ ] Test on different websites

## Troubleshooting

### Extension won't load
- **Error:** "This add-on could not be installed"
- **Solution:** Make sure you're using Firefox 109 or later
- **Check version:** Menu → Help → About Firefox

### Typing doesn't work
- **Solution:** Same troubleshooting as Chrome version (see TROUBLESHOOTING.md)
- **Firefox note:** Press Ctrl+Shift+J (or Cmd+Option+J on Mac) for Browser Console

### Temporary add-on disappears
- **Expected behavior:** Temporary add-ons are removed when you close Firefox
- **Solution:** Load it again, or use permanent installation method

### Can't publish to Add-ons
- **Check:** Make sure `browser_specific_settings.gecko.id` is unique
- **Solution:** Change the ID in `manifest-firefox.json` to use your own domain

## Development

### File Structure for Firefox

```
human-typer/
├── manifest-firefox.json    # Firefox-specific manifest
├── browser-polyfill-lite.js # API compatibility layer
├── popup.html
├── popup.js
├── content.js
├── styles.css
├── icon16.png
├── icon48.png
├── icon128.png
└── package-firefox.sh       # Build script
```

### Building

```bash
# Create Firefox package
./package-firefox.sh

# Creates: human-typer-firefox.zip
```

### Debugging

```bash
# Open Browser Console (all messages)
Ctrl+Shift+J (Windows/Linux)
Cmd+Option+J (Mac)

# Look for messages starting with:
[Human Typer] ...
```

## Resources

- **Firefox Extension Workshop:** https://extensionworkshop.com/
- **MDN Web Extensions:** https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions
- **Add-on Policies:** https://extensionworkshop.com/documentation/publish/add-on-policies/
- **Developer Hub:** https://addons.mozilla.org/developers/

## Support

For issues specific to Firefox:
1. Check the Browser Console for errors
2. Ensure you're on Firefox 109+
3. Try loading temporarily first
4. Check TROUBLESHOOTING.md for common issues

Good luck with your Firefox add-on!
