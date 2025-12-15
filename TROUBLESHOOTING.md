# Troubleshooting Guide

## Common Issues and Solutions

### Issue: Nothing happens when I click "Start Typing"

**Possible Causes:**

1. **You're on a Chrome internal page**
   - **Error message:** "This extension cannot run on Chrome internal pages"
   - **Solution:** Navigate to a regular webpage (like google.com, github.com, etc.)
   - **Why:** Chrome doesn't allow extensions to run on pages like:
     - `chrome://extensions/`
     - `chrome://settings/`
     - `chrome-extension://...`
     - The Chrome Web Store

2. **Content script not loaded**
   - **Error message:** "Could not load extension on this page"
   - **Solution:** Refresh the page (press Ctrl+R or Cmd+R) and try again
   - **Why:** If you loaded the extension after opening the page, the content script may not be injected

3. **No text entered**
   - **Error message:** "Please enter some text to type"
   - **Solution:** Paste or type text into the extension popup before clicking "Start Typing"

4. **Extension needs reload**
   - **Solution:**
     1. Go to `chrome://extensions/`
     2. Find "Human Typer"
     3. Click the refresh/reload icon (circular arrow)
     4. Go back to your webpage and try again

### Issue: Extension loads but typing doesn't start

**Solutions:**

1. **Make sure you clicked on a text field**
   - After clicking "Start Typing", you MUST click into a text input field
   - Valid fields: text inputs, textareas, search boxes, email fields, contenteditable elements

2. **Check the browser console for debug messages**
   - Press `F12` to open DevTools
   - Go to the **Console** tab
   - Look for messages starting with `[Human Typer]`
   - These messages will tell you what's happening

3. **Try the test page**
   - Open `test.html` (included in the extension folder)
   - This page has multiple test fields to verify functionality

### Issue: Typing is too slow/fast

**Solution:**
- Adjust the "Typing Speed" dropdown in the extension popup
- Options: Slow (60-80 WPM), Normal (80-100 WPM), Fast (100-120 WPM)

### Issue: Too many/few typos

**Solution:**
- Adjust the "Typo Frequency" slider in the extension popup
- Range: 0-10%
- Disable typos completely by unchecking "Enable Random Typos"

### Issue: Typing happens in wrong place

**Possible Causes:**

1. **Multiple text fields on page**
   - **Solution:** Make sure you click into the specific field where you want typing to occur
   - The extension types into whichever field you focus AFTER clicking "Start Typing"

2. **Smart Replace mode issues**
   - **Solution:** If you're not trying to replace existing text, uncheck "Smart Replace"

### Issue: Text doesn't sound natural even with Humanize mode

**Solutions:**
- Humanize mode works best with formal English text
- It converts contractions and changes formal phrases
- For best results, start with formal text like:
  - "I am writing to inform you..."
  - "However, I cannot attend..."
  - "Furthermore, I would like to..."

### Issue: Can't upload to Chrome Web Store

**Common Upload Errors:**

1. **"Icon files missing"**
   - **Solution:**
     - Run `python3 generate-icons.py` to create icons
     - Or open `create-icons.html` in a browser and download icons
     - Make sure `icon16.png`, `icon48.png`, and `icon128.png` exist

2. **"Invalid manifest"**
   - **Solution:** Use `./package.sh` to create the ZIP file correctly
   - Don't manually create the ZIP

3. **"Package too large"**
   - **Solution:** Make sure you're not including:
     - `.git` folder
     - `.md` documentation files
     - `test.html`
     - Use `./package.sh` which excludes these automatically

## Debugging Steps

### Step 1: Check Extension is Loaded
1. Go to `chrome://extensions/`
2. Find "Human Typer"
3. Make sure it's **enabled** (toggle switch is on)
4. Note the extension ID

### Step 2: Check Content Script is Running
1. Open a regular webpage (like `test.html` or google.com)
2. Press `F12` to open DevTools
3. Go to **Console** tab
4. You should see: `[Human Typer] Focus listener initialized`
5. If you don't see this, reload the page

### Step 3: Test Message Passing
1. Click the extension icon
2. Enter some text
3. Click "Start Typing"
4. Check the Console for:
   - `[Human Typer] Message received: startTyping`
   - `[Human Typer] Waiting for focus on text field...`
5. Click into a text field
6. Check the Console for:
   - `[Human Typer] Focus event detected on: INPUT text`
   - `[Human Typer] Starting typing on element`

### Step 4: Check for Errors
Look in the Console for any red error messages. Common errors:

- **"Cannot access contents of URL"**
  - You're on a protected page
  - Solution: Navigate to a regular webpage

- **"Could not establish connection"**
  - Content script not loaded
  - Solution: Reload the page

- **"Extension context invalidated"**
  - Extension was reloaded while typing
  - Solution: Close the popup and try again

## Still Having Issues?

If none of these solutions work:

1. **Completely remove and reinstall the extension:**
   - Go to `chrome://extensions/`
   - Click "Remove" on Human Typer
   - Restart Chrome
   - Re-install the extension

2. **Check for conflicts:**
   - Disable other extensions temporarily
   - Some extensions might interfere with text input

3. **Try a different browser:**
   - The extension works on any Chromium-based browser
   - Try Microsoft Edge, Brave, or Opera

4. **Check browser version:**
   - Make sure you're using a recent version of Chrome
   - The extension requires Manifest V3 support (Chrome 88+)

## Getting More Help

If you're still experiencing issues:

1. Open the browser console (F12)
2. Copy all messages starting with `[Human Typer]`
3. Note what page you're on
4. Note what error message appears in the extension popup
5. Report the issue with this information

## Performance Tips

- **Large text blocks:** For very long text (1000+ words), typing will take time. This is intentional for realism.
- **Reduce typos:** Lower the typo frequency for faster typing
- **Faster speed:** Use "Fast" mode (100-120 WPM)
- **Stop mid-typing:** Click the "Stop" button in the popup at any time
