#!/usr/bin/env python3
"""
Human Typer - Desktop Application for Linux
Simulates realistic human typing in any application system-wide
"""

import tkinter as tk
from tkinter import ttk, scrolledtext
import random
import time
import threading
import re
from pynput.keyboard import Controller, Key

class HumanTyper:
    def __init__(self):
        self.keyboard = Controller()
        self.is_typing = False
        self.should_stop = False

        # Typo map - keyboard proximity based errors
        self.typo_map = {
            'a': ['s', 'q'], 'b': ['v', 'n'], 'c': ['x', 'v'], 'd': ['s', 'f'],
            'e': ['w', 'r'], 'f': ['d', 'g'], 'g': ['f', 'h'], 'h': ['g', 'j'],
            'i': ['u', 'o'], 'j': ['h', 'k'], 'k': ['j', 'l'], 'l': ['k', 'o'],
            'm': ['n', 'j'], 'n': ['b', 'm'], 'o': ['i', 'p'], 'p': ['o', 'l'],
            'q': ['w', 'a'], 'r': ['e', 't'], 's': ['a', 'd'], 't': ['r', 'y'],
            'u': ['y', 'i'], 'v': ['c', 'b'], 'w': ['q', 'e'], 'x': ['z', 'c'],
            'y': ['t', 'u'], 'z': ['x', 's']
        }

    def get_typing_delay(self, speed='normal'):
        """Calculate delay between keystrokes based on WPM"""
        speeds = {
            'slow': {'min': 60, 'max': 80},
            'normal': {'min': 80, 'max': 100},
            'fast': {'min': 100, 'max': 120}
        }

        wpm = speeds.get(speed, speeds['normal'])
        cpm = (wpm['min'] + random.random() * (wpm['max'] - wpm['min'])) * 5
        base_delay = 60.0 / cpm

        # Add human variation (±30%)
        variation = base_delay * 0.3
        return base_delay + (random.random() * variation * 2 - variation)

    def generate_typo(self, char):
        """Generate a typo based on keyboard proximity"""
        lower = char.lower()
        if lower in self.typo_map:
            typo = random.choice(self.typo_map[lower])
            return typo.upper() if char.isupper() else typo
        return char

    def humanize_text(self, text):
        """Convert formal text to casual, natural-sounding language"""
        replacements = [
            (r'\bI am\b', "I'm"), (r'\bwe are\b', "we're"),
            (r'\byou are\b', "you're"), (r'\bthey are\b', "they're"),
            (r'\bit is\b', "it's"), (r'\bthat is\b', "that's"),
            (r'\bwho is\b', "who's"), (r'\bwhat is\b', "what's"),
            (r'\bdo not\b', "don't"), (r'\bdoes not\b', "doesn't"),
            (r'\bdid not\b', "didn't"), (r'\bcannot\b', "can't"),
            (r'\bwill not\b', "won't"), (r'\bshould not\b', "shouldn't"),
            (r'\bwould not\b', "wouldn't"), (r'\bcould not\b', "couldn't"),
            (r'\bhave not\b', "haven't"), (r'\bhas not\b', "hasn't"),
            (r'\bhad not\b', "hadn't"), (r'\bI will\b', "I'll"),
            (r'\byou will\b', "you'll"), (r'\bhe will\b', "he'll"),
            (r'\bshe will\b', "she'll"), (r'\bthey will\b', "they'll"),
            (r'\bwe will\b', "we'll"),
            (r'\bIn my opinion,\s*', 'I think ', re.IGNORECASE),
            (r'\bI would like to\b', "I'd like to", re.IGNORECASE),
            (r'\bperhaps\b', 'maybe', re.IGNORECASE),
            (r'\badditionally\b', 'also', re.IGNORECASE),
            (r'\bfurthermore\b', 'plus', re.IGNORECASE),
            (r'\bhowever\b', 'but', re.IGNORECASE),
            (r'\btherefore\b', 'so', re.IGNORECASE),
            (r'\bnevertheless\b', 'still', re.IGNORECASE),
        ]

        humanized = text
        for pattern, replacement, *flags in replacements:
            flag = flags[0] if flags else 0
            humanized = re.sub(pattern, replacement, humanized, flags=flag)

        return humanized

    def type_character(self, char):
        """Type a single character"""
        try:
            self.keyboard.press(char)
            self.keyboard.release(char)
        except Exception as e:
            print(f"Error typing character '{char}': {e}")

    def type_backspace(self):
        """Simulate backspace key"""
        self.keyboard.press(Key.backspace)
        self.keyboard.release(Key.backspace)

    def type_text(self, text, settings, progress_callback=None):
        """Type text with human-like behavior"""
        self.is_typing = True
        self.should_stop = False

        chars = list(text)
        total_chars = len(chars)

        for i, char in enumerate(chars):
            if self.should_stop:
                print("Typing stopped by user")
                break

            delay = self.get_typing_delay(settings['speed'])

            # Decide if we should make a typo
            should_typo = (settings['typos'] and
                          random.random() * 100 < settings['typo_frequency'] and
                          char.isalpha())

            if should_typo:
                # Type wrong character
                typo_char = self.generate_typo(char)
                self.type_character(typo_char)
                time.sleep(delay)

                # Pause (human realizes mistake)
                time.sleep(delay * 2)

                # Backspace
                self.type_backspace()
                time.sleep(delay * 0.5)

                # Type correct character
                self.type_character(char)
            else:
                # Type normally
                self.type_character(char)

            # Random pauses (thinking)
            if random.random() > 0.95:
                time.sleep(delay * 3)

            time.sleep(delay)

            # Update progress
            if progress_callback and i % 10 == 0:
                progress = int((i / total_chars) * 100)
                progress_callback(progress)

        self.is_typing = False
        if progress_callback:
            progress_callback(100)

    def stop_typing(self):
        """Stop the current typing operation"""
        self.should_stop = True


class HumanTyperGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("Human Typer - Desktop")
        self.root.geometry("600x700")
        self.root.resizable(True, True)

        self.typer = HumanTyper()
        self.typing_thread = None

        self.setup_ui()

    def setup_ui(self):
        """Setup the user interface"""
        # Main container
        main_frame = ttk.Frame(self.root, padding="10")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))

        # Configure grid weights
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
        main_frame.columnconfigure(0, weight=1)
        main_frame.rowconfigure(1, weight=1)

        # Title
        title_label = ttk.Label(main_frame, text="Human Typer",
                               font=('Arial', 20, 'bold'))
        title_label.grid(row=0, column=0, pady=10)

        # Text input area
        text_frame = ttk.LabelFrame(main_frame, text="Text to Type", padding="10")
        text_frame.grid(row=1, column=0, sticky=(tk.W, tk.E, tk.N, tk.S), pady=10)
        text_frame.columnconfigure(0, weight=1)
        text_frame.rowconfigure(0, weight=1)

        self.text_input = scrolledtext.ScrolledText(text_frame, wrap=tk.WORD,
                                                    height=10, font=('Arial', 11))
        self.text_input.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        self.text_input.insert(1.0, "Paste or type your text here...")

        # Options frame
        options_frame = ttk.LabelFrame(main_frame, text="Options", padding="10")
        options_frame.grid(row=2, column=0, sticky=(tk.W, tk.E), pady=10)

        # Humanize checkbox
        self.humanize_var = tk.BooleanVar(value=False)
        humanize_check = ttk.Checkbutton(options_frame,
                                        text="Humanize Text (make it sound more natural)",
                                        variable=self.humanize_var)
        humanize_check.grid(row=0, column=0, sticky=tk.W, pady=5)

        # Enable typos checkbox
        self.typos_var = tk.BooleanVar(value=True)
        typos_check = ttk.Checkbutton(options_frame,
                                     text="Enable Random Typos",
                                     variable=self.typos_var)
        typos_check.grid(row=1, column=0, sticky=tk.W, pady=5)

        # Typing speed
        speed_frame = ttk.Frame(options_frame)
        speed_frame.grid(row=2, column=0, sticky=(tk.W, tk.E), pady=5)

        ttk.Label(speed_frame, text="Typing Speed:").pack(side=tk.LEFT, padx=5)
        self.speed_var = tk.StringVar(value='normal')
        speed_combo = ttk.Combobox(speed_frame, textvariable=self.speed_var,
                                   values=['slow', 'normal', 'fast'],
                                   state='readonly', width=15)
        speed_combo.pack(side=tk.LEFT, padx=5)

        # Typo frequency
        typo_freq_frame = ttk.Frame(options_frame)
        typo_freq_frame.grid(row=3, column=0, sticky=(tk.W, tk.E), pady=5)

        ttk.Label(typo_freq_frame, text="Typo Frequency:").pack(side=tk.LEFT, padx=5)
        self.typo_freq_var = tk.IntVar(value=3)
        typo_scale = ttk.Scale(typo_freq_frame, from_=0, to=10,
                              variable=self.typo_freq_var, orient=tk.HORIZONTAL)
        typo_scale.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=5)

        self.typo_freq_label = ttk.Label(typo_freq_frame, text="3%")
        self.typo_freq_label.pack(side=tk.LEFT, padx=5)

        # Update label when scale changes
        typo_scale.configure(command=lambda v: self.typo_freq_label.configure(
            text=f"{int(float(v))}%"))

        # Delay before typing
        delay_frame = ttk.Frame(options_frame)
        delay_frame.grid(row=4, column=0, sticky=(tk.W, tk.E), pady=5)

        ttk.Label(delay_frame, text="Delay before typing (seconds):").pack(side=tk.LEFT, padx=5)
        self.delay_var = tk.IntVar(value=3)
        delay_spin = ttk.Spinbox(delay_frame, from_=0, to=10,
                                textvariable=self.delay_var, width=10)
        delay_spin.pack(side=tk.LEFT, padx=5)

        # Instructions
        instructions_frame = ttk.LabelFrame(main_frame, text="Instructions", padding="10")
        instructions_frame.grid(row=3, column=0, sticky=(tk.W, tk.E), pady=10)

        instructions = (
            "1. Enter or paste your text above\n"
            "2. Configure your settings\n"
            "3. Click 'Start Typing'\n"
            "4. You have 3 seconds (or your chosen delay) to click on the target text field\n"
            "5. Watch as the text types automatically!\n"
            "\n"
            "Note: Works in ANY application - browsers, text editors, terminals, etc."
        )
        instructions_label = ttk.Label(instructions_frame, text=instructions,
                                      justify=tk.LEFT, foreground='#555')
        instructions_label.pack(anchor=tk.W)

        # Progress bar
        self.progress_var = tk.IntVar(value=0)
        self.progress_bar = ttk.Progressbar(main_frame, variable=self.progress_var,
                                           maximum=100, mode='determinate')
        self.progress_bar.grid(row=4, column=0, sticky=(tk.W, tk.E), pady=10)

        # Buttons frame
        buttons_frame = ttk.Frame(main_frame)
        buttons_frame.grid(row=5, column=0, pady=10)

        self.start_button = ttk.Button(buttons_frame, text="Start Typing",
                                      command=self.start_typing)
        self.start_button.pack(side=tk.LEFT, padx=5)

        self.stop_button = ttk.Button(buttons_frame, text="Stop",
                                     command=self.stop_typing, state='disabled')
        self.stop_button.pack(side=tk.LEFT, padx=5)

        # Status label
        self.status_var = tk.StringVar(value="Ready")
        self.status_label = ttk.Label(main_frame, textvariable=self.status_var,
                                     font=('Arial', 10), foreground='#666')
        self.status_label.grid(row=6, column=0, pady=5)

    def update_progress(self, value):
        """Update progress bar from typing thread"""
        self.progress_var.set(value)
        if value >= 100:
            self.status_var.set("Typing complete!")
            self.start_button.configure(state='normal')
            self.stop_button.configure(state='disabled')

    def start_typing(self):
        """Start the typing process"""
        text = self.text_input.get(1.0, tk.END).strip()

        if not text:
            self.status_var.set("Error: Please enter some text!")
            return

        # Humanize text if enabled
        if self.humanize_var.get():
            text = self.typer.humanize_text(text)
            # Update text area to show humanized version
            self.text_input.delete(1.0, tk.END)
            self.text_input.insert(1.0, text)

        # Get settings
        settings = {
            'speed': self.speed_var.get(),
            'typos': self.typos_var.get(),
            'typo_frequency': self.typo_freq_var.get()
        }

        # Get delay
        delay = self.delay_var.get()

        # Update UI
        self.start_button.configure(state='disabled')
        self.stop_button.configure(state='normal')
        self.progress_var.set(0)

        # Countdown
        for i in range(delay, 0, -1):
            self.status_var.set(f"Click on target text field... {i}")
            self.root.update()
            time.sleep(1)

        self.status_var.set("Typing...")

        # Start typing in a separate thread
        self.typing_thread = threading.Thread(
            target=self.typer.type_text,
            args=(text, settings, self.update_progress),
            daemon=True
        )
        self.typing_thread.start()

    def stop_typing(self):
        """Stop the current typing operation"""
        self.typer.stop_typing()
        self.status_var.set("Typing stopped")
        self.start_button.configure(state='normal')
        self.stop_button.configure(state='disabled')


def main():
    """Main entry point"""
    root = tk.Tk()
    app = HumanTyperGUI(root)
    root.mainloop()


if __name__ == '__main__':
    main()
