#!/bin/bash
# 🤖 Agent Desktop — Opens iTerm2 with project tabs

open -a iTerm
sleep 2

# Use Python to drive iTerm2's AppleScript (more reliable escaping)
python3 -c "
import subprocess, time

def iterm(cmd):
    subprocess.run(['osascript', '-e', cmd])

# First tab - Verble2
iterm('tell application \"iTerm2\" to tell current session of current window to write text \"cd ~/work/verble2 && echo 🔵\\\\ Verble2 && git status\"')

time.sleep(0.3)

# New tabs
tabs = [
    ('cd ~/work/niche-finder && echo 🟢\\\\ Niche-Finder && git status'),
    ('cd ~/work/wedding-speech && echo 💒\\\\ Wedding-Speech && git status'),
    ('cd ~/.openclaw/workspace-verble-support && echo 🎧\\\\ Support'),
    ('cd ~/.openclaw/workspace-maison && echo 🏠\\\\ Maison'),
    ('cd ~/work && echo ⚡\\\\ Scratch && ls'),
]

for cmd in tabs:
    # Cmd+T to create new tab
    subprocess.run(['osascript', '-e', 'tell application \"System Events\" to tell process \"iTerm2\" to keystroke \"t\" using command down'])
    time.sleep(0.5)
    iterm(f'tell application \"iTerm2\" to tell current session of current window to write text \"{cmd}\"')
    time.sleep(0.3)

# Go back to first tab: Cmd+1
subprocess.run(['osascript', '-e', 'tell application \"System Events\" to tell process \"iTerm2\" to keystroke \"1\" using command down'])
"
