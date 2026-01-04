# Human Typer

Simulate realistic human typing with variable speed, occasional typos, and text humanization features.

## Available Versions

**🌐 Browser Extension** (Chrome, Firefox, Edge)
- Works in all web browsers
- No installation required (from store)
- Perfect for web forms and online applications
- [Chrome Installation](#installation) (see below)
- [Firefox Installation](FIREFOX.md)

**🐧 Linux Desktop App** (System-Wide)
- Works in **ANY application** on Linux
- Text editors, terminals, IDEs, browsers, everything!
- Standalone Python application
- [Linux App Installation](linux-app/README.md)

Choose the version that fits your needs:
- **Browser only?** → Use the browser extension
- **Need system-wide typing on Linux?** → Use the desktop app
- **Both?** → Install both!

---

## Browser Extension

## Features

- **Human-like Typing Speed**: Choose from slow (60-80 WPM), normal (80-100 WPM), or fast (100-120 WPM) typing speeds
- **Realistic Typos**: Randomly generates common typing mistakes based on keyboard proximity, then corrects them
- **Text Humanization**: Converts formal text to casual, natural-sounding language with contractions and filler words
- **Smart Replace**: Intelligently detects matching text and only types the new/different portions
- **Adjustable Typo Frequency**: Control how often typos occur (0-10%)
- **Natural Variations**: Random pauses and speed variations to mimic real human typing patterns

## Installation

### Method 1: Install from Chrome Web Store (Recommended)

**Coming Soon!** Once published, you'll be able to install with one click from the Chrome Web Store.

**Want to publish it yourself?** See [PUBLISHING.md](PUBLISHING.md) for complete instructions.

### Method 2: Load Unpacked Extension (Development)

Perfect for testing or personal use:

1. Download or clone this repository
2. **(Optional)** Create icons: Open `create-icons.html` in your browser and download the icons
3. Open Chrome and navigate to `chrome://extensions/`
4. Enable "Developer mode" using the toggle in the top-right corner
5. Click "Load unpacked"
6. Select the folder containing the extension files
7. The extension should now appear in your extensions list

**Note:** The extension works without custom icons, but Chrome will show a default icon.

## Usage

### Basic Usage

1. Click the Human Typer extension icon in your Chrome toolbar
2. Paste or type the text you want to simulate typing
3. Configure your settings (optional):
   - **Humanize Text**: Makes text sound more natural and casual
   - **Smart Replace**: Only types new text when replacing highlighted content
   - **Enable Random Typos**: Adds realistic typing mistakes
   - **Typing Speed**: Choose your preferred WPM range
   - **Typo Frequency**: Adjust how often typos occur
4. Click "Start Typing"
5. Click into any text field (textarea, input, or contenteditable element)
6. Watch as the extension types your text with human-like behavior

### Smart Replace Feature

The Smart Replace feature is particularly useful when you want to modify existing text:

1. **Highlight/select** the text in a text field that you want to replace
2. In the extension, paste the **new text** (can include parts of the old text)
3. Enable "Smart Replace"
4. Click "Start Typing" and focus the text field
5. The extension will detect the common prefix and only type the changed portion

**Example:**
- Original text: "Hello, my name is John"
- You select: "Hello, my name is John"
- New text: "Hello, my name is Jane and I love coding"
- Result: It will only type "Jane and I love coding" (skipping "Hello, my name is " which is identical)

### Humanize Mode

The Humanize feature transforms formal text into more casual, natural-sounding language:

**Transformations include:**
- Contractions: "I am" → "I'm", "do not" → "don't"
- Casual phrases: "In my opinion" → "I think", "perhaps" → "maybe"
- Filler words: Adds "So,", "Well,", "Actually," at sentence starts
- Less formal conjunctions: "furthermore" → "plus", "however" → "but"

**Example:**
- Input: "I am writing to inform you that I cannot attend. However, I would like to participate."
- Output: "I'm writing to inform you that I can't attend. But, I'd like to participate."

### Stopping Mid-Typing

If you need to stop the typing simulation:
- Click the "Stop" button in the extension popup
- The typing will halt immediately

## Settings Explained

### Typing Speed
- **Slow (60-80 WPM)**: Beginner-level typing speed
- **Normal (80-100 WPM)**: Average typing speed (recommended)
- **Fast (100-120 WPM)**: Professional typing speed

### Typo Frequency
- Range: 0-10%
- Recommended: 2-4% for realistic simulation
- Higher values = more frequent typos and corrections

### Enable Random Typos
When enabled, the extension will:
1. Occasionally type the wrong character (based on keyboard proximity)
2. Pause briefly (simulating realization)
3. Press backspace to delete the mistake
4. Type the correct character

## How It Works

The extension uses several techniques to simulate human typing:

1. **Variable Speed**: Each keystroke has a randomized delay based on your WPM setting
2. **Keyboard Proximity Typos**: Mistakes are based on actual keyboard layout (e.g., 'a' might be mistyped as 's' or 'q')
3. **Natural Pauses**: Random longer pauses (~5% of keystrokes) simulate thinking
4. **Proper Events**: Dispatches real keyboard and input events that work with web frameworks
5. **Smart Diffing**: Compares strings character-by-character to find common prefixes

## Technical Details

### Files
- `manifest.json`: Extension configuration
- `popup.html`: Extension popup UI
- `popup.js`: Popup logic and text humanization
- `content.js`: Content script for typing simulation
- `styles.css`: Popup styling

### Permissions
- `activeTab`: Required to interact with the current tab
- `scripting`: Required to inject the content script

### Browser Compatibility
- Chrome (Manifest V3)
- Edge (Chromium-based)
- Other Chromium-based browsers

## Privacy

This extension:
- Does NOT collect any data
- Does NOT send any information to external servers
- Runs entirely locally in your browser
- Only accesses the active tab when you click "Start Typing"

## Troubleshooting

### Extension doesn't work on certain pages
Some websites have strict Content Security Policies that may block the extension. Try it on different websites.

### Typing doesn't start
Make sure to:
1. Click "Start Typing" in the popup
2. Click into a text field (input, textarea, or contenteditable element)
3. Check that the website allows text input in that field

### Typos aren't appearing
- Increase the "Typo Frequency" slider
- Make sure "Enable Random Typos" is checked
- Typos only occur on alphabetic characters

### Text isn't humanized
- Make sure "Humanize Text" checkbox is enabled
- The humanization works best on formal English text
- Check the textarea in the popup to see the humanized version before typing

## Future Enhancements

Potential features for future versions:
- Custom typing patterns and profiles
- Pause/resume functionality
- Keyboard shortcut support
- Support for multiple languages
- Advanced AI-based text humanization
- Custom typo patterns

## License

MIT License - feel free to modify and distribute

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## Author

Created for realistic text input simulation and testing purposes.
