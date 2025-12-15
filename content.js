// Content script for human-like typing simulation

let typingSettings = null;
let isTyping = false;
let shouldStop = false;
let activeElement = null;

// Common typo patterns (letter -> common mistakes)
const typoMap = {
  'a': ['s', 'q'],
  'b': ['v', 'n'],
  'c': ['x', 'v'],
  'd': ['s', 'f'],
  'e': ['w', 'r'],
  'f': ['d', 'g'],
  'g': ['f', 'h'],
  'h': ['g', 'j'],
  'i': ['u', 'o'],
  'j': ['h', 'k'],
  'k': ['j', 'l'],
  'l': ['k', 'o'],
  'm': ['n', 'j'],
  'n': ['b', 'm'],
  'o': ['i', 'p'],
  'p': ['o', 'l'],
  'q': ['w', 'a'],
  'r': ['e', 't'],
  's': ['a', 'd'],
  't': ['r', 'y'],
  'u': ['y', 'i'],
  'v': ['c', 'b'],
  'w': ['q', 'e'],
  'x': ['z', 'c'],
  'y': ['t', 'u'],
  'z': ['x', 's']
};

// Get typing delay based on speed setting
function getTypingDelay(speed) {
  // WPM to characters per minute (avg 5 chars per word)
  // Then to milliseconds per character
  const speeds = {
    'slow': { min: 60, max: 80 },    // 60-80 WPM
    'normal': { min: 80, max: 100 },  // 80-100 WPM
    'fast': { min: 100, max: 120 }    // 100-120 WPM
  };

  const wpm = speeds[speed] || speeds['normal'];
  const cpm = (wpm.min + Math.random() * (wpm.max - wpm.min)) * 5;
  const baseDelay = 60000 / cpm;

  // Add human variation (±30%)
  const variation = baseDelay * 0.3;
  return baseDelay + (Math.random() * variation * 2 - variation);
}

// Generate a typo for a character
function generateTypo(char) {
  const lower = char.toLowerCase();
  if (typoMap[lower]) {
    const typos = typoMap[lower];
    const typo = typos[Math.floor(Math.random() * typos.length)];
    return char === char.toUpperCase() ? typo.toUpperCase() : typo;
  }
  return char;
}

// Sleep function
function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

// Simulate typing a single character
async function typeCharacter(element, char, isTypo = false) {
  // Create and dispatch input events
  const inputEvent = new InputEvent('input', {
    bubbles: true,
    cancelable: true,
    inputType: 'insertText',
    data: char
  });

  const keydownEvent = new KeyboardEvent('keydown', {
    bubbles: true,
    cancelable: true,
    key: char,
    char: char
  });

  const keypressEvent = new KeyboardEvent('keypress', {
    bubbles: true,
    cancelable: true,
    key: char,
    char: char
  });

  const keyupEvent = new KeyboardEvent('keyup', {
    bubbles: true,
    cancelable: true,
    key: char,
    char: char
  });

  element.dispatchEvent(keydownEvent);
  element.dispatchEvent(keypressEvent);

  // Update the value
  const start = element.selectionStart;
  const end = element.selectionEnd;
  const value = element.value;
  element.value = value.substring(0, start) + char + value.substring(end);
  element.selectionStart = element.selectionEnd = start + 1;

  element.dispatchEvent(inputEvent);
  element.dispatchEvent(keyupEvent);

  // Trigger change event for frameworks
  element.dispatchEvent(new Event('change', { bubbles: true }));
}

// Simulate backspace
async function typeBackspace(element) {
  const backspaceDown = new KeyboardEvent('keydown', {
    bubbles: true,
    cancelable: true,
    key: 'Backspace',
    keyCode: 8
  });

  const backspaceUp = new KeyboardEvent('keyup', {
    bubbles: true,
    cancelable: true,
    key: 'Backspace',
    keyCode: 8
  });

  element.dispatchEvent(backspaceDown);

  const start = element.selectionStart;
  const end = element.selectionEnd;
  const value = element.value;

  if (start > 0) {
    element.value = value.substring(0, start - 1) + value.substring(end);
    element.selectionStart = element.selectionEnd = start - 1;
  }

  const inputEvent = new InputEvent('input', {
    bubbles: true,
    cancelable: true,
    inputType: 'deleteContentBackward'
  });

  element.dispatchEvent(inputEvent);
  element.dispatchEvent(backspaceUp);
  element.dispatchEvent(new Event('change', { bubbles: true }));
}

// Find common prefix between two strings
function findCommonPrefix(str1, str2) {
  let i = 0;
  const minLength = Math.min(str1.length, str2.length);

  while (i < minLength && str1[i] === str2[i]) {
    i++;
  }

  return i;
}

// Main typing function
async function startHumanTyping(element, text, settings) {
  isTyping = true;
  shouldStop = false;
  activeElement = element;

  let textToType = text;

  // Smart diff: check if highlighted text matches beginning of input
  if (settings.smartDiff) {
    const currentText = element.value;
    const selectedText = currentText.substring(element.selectionStart, element.selectionEnd);

    if (selectedText) {
      // Find common prefix between selected text and new text
      const commonLength = findCommonPrefix(selectedText, text);

      if (commonLength > 0) {
        // Only type the part that's different
        textToType = text.substring(commonLength);

        // Move cursor to end of common prefix
        const newStart = element.selectionStart + commonLength;
        element.selectionStart = newStart;
        element.selectionEnd = element.selectionEnd;
      }
    }
  }

  const chars = textToType.split('');
  let charIndex = 0;

  while (charIndex < chars.length && !shouldStop) {
    const char = chars[charIndex];
    const delay = getTypingDelay(settings.speed);

    // Decide if we should make a typo
    const shouldTypo = settings.typos &&
                       Math.random() * 100 < settings.typoFrequency &&
                       char.match(/[a-zA-Z]/);

    if (shouldTypo) {
      // Type the wrong character
      const typoChar = generateTypo(char);
      await typeCharacter(element, typoChar, true);
      await sleep(delay);

      // Pause (human realizes mistake)
      await sleep(delay * 2);

      // Backspace
      await typeBackspace(element);
      await sleep(delay * 0.5);

      // Type correct character
      await typeCharacter(element, char);
    } else {
      // Type normally
      await typeCharacter(element, char);
    }

    // Random pauses (thinking)
    if (Math.random() > 0.95) {
      await sleep(delay * 3);
    }

    await sleep(delay);
    charIndex++;

    // Send progress update
    const progress = Math.round((charIndex / chars.length) * 100);
    if (charIndex % 10 === 0) {
      try {
        chrome.runtime.sendMessage({
          action: 'typingProgress',
          progress: progress
        });
      } catch (e) {
        // Popup might be closed, that's okay
      }
    }
  }

  isTyping = false;

  if (shouldStop) {
    try {
      chrome.runtime.sendMessage({
        action: 'typingError',
        error: 'Typing was stopped by user'
      });
    } catch (e) {
      console.log('[Human Typer] Could not send stop message (popup may be closed)');
    }
  } else {
    try {
      chrome.runtime.sendMessage({
        action: 'typingComplete'
      });
    } catch (e) {
      console.log('[Human Typer] Could not send completion message (popup may be closed)');
    }
  }
}

// Listen for focus on input fields
let waitingForFocus = false;
let pendingSettings = null;

// Check if element is a valid text input
function isTextInput(element) {
  if (!element) return false;

  // Check for textarea
  if (element.tagName === 'TEXTAREA') {
    return true;
  }

  // Check for contenteditable
  if (element.isContentEditable) {
    return true;
  }

  // Check for text input types
  if (element.tagName === 'INPUT') {
    const type = (element.type || 'text').toLowerCase();
    const validTypes = ['text', 'email', 'password', 'search', 'tel', 'url', 'number'];
    return validTypes.includes(type);
  }

  return false;
}

function setupFocusListener() {
  console.log('[Human Typer] Focus listener initialized');

  document.addEventListener('focus', async (e) => {
    console.log('[Human Typer] Focus event detected on:', e.target.tagName, e.target.type);

    if (waitingForFocus && isTextInput(e.target)) {
      console.log('[Human Typer] Starting typing on element');
      waitingForFocus = false;
      await startHumanTyping(e.target, pendingSettings.text, pendingSettings);
      pendingSettings = null;
    }
  }, true);

  // Also listen for click events as backup
  document.addEventListener('click', async (e) => {
    if (waitingForFocus && isTextInput(e.target)) {
      console.log('[Human Typer] Starting typing via click on element');
      e.target.focus();
      waitingForFocus = false;
      await startHumanTyping(e.target, pendingSettings.text, pendingSettings);
      pendingSettings = null;
    }
  }, true);
}

// Initialize focus listener on load
setupFocusListener();

// Listen for messages from popup
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  console.log('[Human Typer] Message received:', message.action);

  if (message.action === 'startTyping') {
    typingSettings = message.settings;
    pendingSettings = message.settings;
    waitingForFocus = true;

    console.log('[Human Typer] Waiting for focus on text field...');
    console.log('[Human Typer] Text to type:', message.settings.text.substring(0, 50) + '...');

    // If there's already a focused element, start typing immediately
    const activeEl = document.activeElement;
    console.log('[Human Typer] Currently focused element:', activeEl?.tagName, activeEl?.type);

    if (activeEl && isTextInput(activeEl)) {
      console.log('[Human Typer] Starting typing immediately on focused element');
      waitingForFocus = false;
      startHumanTyping(activeEl, message.settings.text, message.settings);
      pendingSettings = null;
    } else {
      console.log('[Human Typer] No valid text field focused. Click on a text field to start.');
    }

    sendResponse({ success: true });
  } else if (message.action === 'stopTyping') {
    console.log('[Human Typer] Stopping typing');
    shouldStop = true;
    waitingForFocus = false;
    pendingSettings = null;
    sendResponse({ success: true });
  }

  return true;
});
