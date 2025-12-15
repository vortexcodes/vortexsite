// Get DOM elements
const textInput = document.getElementById('textInput');
const humanizeMode = document.getElementById('humanizeMode');
const smartDiff = document.getElementById('smartDiff');
const enableTypos = document.getElementById('enableTypos');
const typingSpeed = document.getElementById('typingSpeed');
const typoFrequency = document.getElementById('typoFrequency');
const typoFrequencyValue = document.getElementById('typoFrequencyValue');
const startButton = document.getElementById('startTyping');
const stopButton = document.getElementById('stopTyping');
const status = document.getElementById('status');

// Update typo frequency display
typoFrequency.addEventListener('input', (e) => {
  typoFrequencyValue.textContent = `${e.target.value}%`;
});

// Text humanization function
function humanizeText(text) {
  const replacements = [
    // Formal to casual
    { from: /\bI am\b/g, to: "I'm" },
    { from: /\bwe are\b/g, to: "we're" },
    { from: /\byou are\b/g, to: "you're" },
    { from: /\bthey are\b/g, to: "they're" },
    { from: /\bit is\b/g, to: "it's" },
    { from: /\bthat is\b/g, to: "that's" },
    { from: /\bwho is\b/g, to: "who's" },
    { from: /\bwhat is\b/g, to: "what's" },
    { from: /\bdo not\b/g, to: "don't" },
    { from: /\bdoes not\b/g, to: "doesn't" },
    { from: /\bdid not\b/g, to: "didn't" },
    { from: /\bcannot\b/g, to: "can't" },
    { from: /\bwill not\b/g, to: "won't" },
    { from: /\bshould not\b/g, to: "shouldn't" },
    { from: /\bwould not\b/g, to: "wouldn't" },
    { from: /\bcould not\b/g, to: "couldn't" },
    { from: /\bhave not\b/g, to: "haven't" },
    { from: /\bhas not\b/g, to: "hasn't" },
    { from: /\bhad not\b/g, to: "hadn't" },
    { from: /\bI will\b/g, to: "I'll" },
    { from: /\byou will\b/g, to: "you'll" },
    { from: /\bhe will\b/g, to: "he'll" },
    { from: /\bshe will\b/g, to: "she'll" },
    { from: /\bthey will\b/g, to: "they'll" },
    { from: /\bwe will\b/g, to: "we'll" },

    // Remove overly formal phrases
    { from: /\bIn my opinion,\s*/gi, to: "I think " },
    { from: /\bI would like to\b/gi, to: "I'd like to" },
    { from: /\bperhaps\b/gi, to: "maybe" },
    { from: /\badditionally\b/gi, to: "also" },
    { from: /\bfurthermore\b/gi, to: "plus" },
    { from: /\bhowever\b/gi, to: "but" },
    { from: /\btherefore\b/gi, to: "so" },
    { from: /\bnevertheless\b/gi, to: "still" },

    // Add filler words occasionally
    { from: /\b(I think|I believe)\b/gi, to: (match) => Math.random() > 0.5 ? match : "I mean, " + match.toLowerCase() },
  ];

  let humanized = text;

  replacements.forEach(({ from, to }) => {
    if (typeof to === 'function') {
      humanized = humanized.replace(from, to);
    } else {
      humanized = humanized.replace(from, to);
    }
  });

  // Add occasional filler words at sentence starts
  const fillers = ['So, ', 'Well, ', 'You know, ', 'Like, ', 'Actually, '];
  humanized = humanized.split('. ').map((sentence, index) => {
    if (index > 0 && Math.random() > 0.7) {
      const filler = fillers[Math.floor(Math.random() * fillers.length)];
      return filler + sentence.charAt(0).toLowerCase() + sentence.slice(1);
    }
    return sentence;
  }).join('. ');

  return humanized;
}

// Simple diff function to find common prefix
function findCommonPrefix(str1, str2) {
  let i = 0;
  const minLength = Math.min(str1.length, str2.length);

  while (i < minLength && str1[i] === str2[i]) {
    i++;
  }

  return i;
}

// Start typing
startButton.addEventListener('click', async () => {
  let text = textInput.value.trim();

  if (!text) {
    showStatus('Please enter some text to type', 'error');
    return;
  }

  // Humanize text if enabled
  if (humanizeMode.checked) {
    text = humanizeText(text);
    textInput.value = text; // Show humanized text
  }

  // Get typing settings
  const settings = {
    text: text,
    speed: typingSpeed.value,
    typos: enableTypos.checked,
    typoFrequency: parseInt(typoFrequency.value),
    smartDiff: smartDiff.checked
  };

  // Disable start button, enable stop button
  startButton.disabled = true;
  stopButton.disabled = false;

  showStatus('Click on any text field to start typing...', 'info');

  // Send message to content script
  try {
    const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });

    await chrome.tabs.sendMessage(tab.id, {
      action: 'startTyping',
      settings: settings
    });

  } catch (error) {
    console.error('Error:', error);
    showStatus('Error: Make sure you\'re on a valid webpage', 'error');
    startButton.disabled = false;
    stopButton.disabled = true;
  }
});

// Stop typing
stopButton.addEventListener('click', async () => {
  try {
    const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });

    await chrome.tabs.sendMessage(tab.id, {
      action: 'stopTyping'
    });

    startButton.disabled = false;
    stopButton.disabled = true;
    showStatus('Typing stopped', 'info');

  } catch (error) {
    console.error('Error:', error);
  }
});

// Listen for messages from content script
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.action === 'typingComplete') {
    startButton.disabled = false;
    stopButton.disabled = true;
    showStatus('Typing complete!', 'success');
  } else if (message.action === 'typingError') {
    startButton.disabled = false;
    stopButton.disabled = true;
    showStatus('Error: ' + message.error, 'error');
  } else if (message.action === 'typingProgress') {
    showStatus(`Typing... ${message.progress}%`, 'info');
  }
});

// Show status message
function showStatus(message, type) {
  status.textContent = message;
  status.className = `status show ${type}`;

  if (type === 'success' || type === 'error') {
    setTimeout(() => {
      status.classList.remove('show');
    }, 3000);
  }
}
