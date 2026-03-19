#!/bin/bash
# 🤖 Agent Matrix — 3x3 Cyberpunk Edition

open -a iTerm
sleep 2

python3 << 'PYEOF'
import subprocess, time

def osascript(cmd):
    subprocess.run(['osascript', '-e', cmd], capture_output=True)

def keystroke(key, modifier='command down'):
    osascript(f'tell application "System Events" to tell process "iTerm2" to keystroke "{key}" using {modifier}')

def write_text(text):
    osascript(f'tell application "iTerm2" to tell current session of current window to write text "{text}"')

def set_colors(bg_r, bg_g, bg_b, fg_r, fg_g, fg_b):
    # iTerm2 uses 0-65535 range
    osascript(f'tell application "iTerm2" to tell current session of current window to set background color to {{{bg_r}, {bg_g}, {bg_b}}}')
    time.sleep(0.05)
    osascript(f'tell application "iTerm2" to tell current session of current window to set foreground color to {{{fg_r}, {fg_g}, {fg_b}}}')
    time.sleep(0.05)
    osascript(f'tell application "iTerm2" to tell current session of current window to set cursor color to {{{fg_r}, {fg_g}, {fg_b}}}')

def split_v():
    keystroke('d')
    time.sleep(0.5)

def split_h():
    keystroke('d', '{shift down, command down}')
    time.sleep(0.5)

def nav(direction):
    osascript(f'tell application "System Events" to tell process "iTerm2" to key code {direction} using {{option down, command down}}')
    time.sleep(0.3)

LEFT, RIGHT, DOWN, UP = 123, 124, 125, 126

# Build 3x3 grid
split_v()
split_v()

for _ in range(3): nav(LEFT)
split_h()
split_h()

nav(RIGHT)
for _ in range(3): nav(UP)
split_h()
split_h()

nav(RIGHT)
for _ in range(3): nav(UP)
split_h()
split_h()

time.sleep(0.5)

for _ in range(4): nav(LEFT)
for _ in range(4): nav(UP)
time.sleep(0.3)

# Cyberpunk palette — bold, distinct colors per project
# Each pane: (label, bg_r, bg_g, bg_b, fg_r, fg_g, fg_b, directory)
panes = [
    # Row 1
    ("🔵 Verble2",
     1500, 2000, 8000,      # BLUE — the main product
     45000, 55000, 65000,    # light blue text
     "~/work/verble2"),

    ("🟢 Niche Finder",
     1500, 6500, 2000,      # GREEN — exploration/discovery
     40000, 65000, 45000,    # light green text
     "~/work/niche-finder"),

    ("💒 Wedding",
     7000, 1500, 5500,      # HOT PINK — love/wedding
     65000, 40000, 60000,    # soft pink text
     "~/work/wedding-speech"),

    # Row 2
    ("🎧 Support",
     7500, 4000, 1000,      # ORANGE — support/attention
     65000, 55000, 35000,    # warm yellow text
     "~/.openclaw/workspace-verble-support"),

    ("🏠 Maison",
     1000, 5500, 7000,      # TEAL — home/calm
     35000, 62000, 65000,    # cyan text
     "~/.openclaw/workspace-maison"),

    ("📊 Verbl3",
     5500, 1500, 7500,      # PURPLE — next gen
     55000, 40000, 65000,    # lavender text
     "~/work/verbl3"),

    # Row 3
    ("🎬 ReelSermon",
     8000, 1500, 1500,      # RED — video/action
     65000, 42000, 42000,    # soft red text
     "~/work/reelsermon-outreach"),

    ("💰 Trader",
     6500, 6500, 1000,      # YELLOW — money/gold
     62000, 62000, 38000,    # gold text
     "~/.openclaw/workspace-trader"),

    ("🤖 Kash",
     2000, 2000, 2000,      # DARK GREY — neutral/main
     52000, 52000, 58000,    # silver text
     "~/.openclaw/workspace"),
]

for idx, (label, br, bg, bb, fr, fg, fb, directory) in enumerate(panes):
    set_colors(br, bg, bb, fr, fg, fb)
    time.sleep(0.15)
    write_text(f"cd {directory} && clear && echo '' && echo '  {label}' && echo ''")
    time.sleep(0.2)

    if idx < 8:
        if (idx + 1) % 3 == 0:
            nav(RIGHT)
            for _ in range(3): nav(UP)
        else:
            nav(DOWN)

print("🤖 Cyberpunk Matrix ready!")
PYEOF
