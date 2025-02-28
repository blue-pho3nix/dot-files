#!/bin/sh

# Get the focused window's ID
focused_window=$(xdotool getwindowfocus)

# Get the PID of the focused terminal window
terminal_pid=$(xdotool getwindowpid "$focused_window")

# Get the command of the terminal process
command=$(ps -o command= -p "$terminal_pid")

# Initialize working_directory as home
working_directory=$HOME

# Check if the command is a terminal
if echo "$command" | grep -q -E "xterm|urxvt|alacritty|gnome-terminal|konsole|terminator"; then
    # Find the shell process related to the terminal
    shell_pid=$(pgrep -P "$terminal_pid" | head -n 1)

    # Get the working directory of the shell process
    working_directory=$(readlink /proc/$shell_pid/cwd)

    # If still empty, fallback to home
    if [ -z "$working_directory" ]; then
        working_directory=$HOME
    fi
fi

# Launch Alacritty in the detected directory
alacritty --working-directory "$working_directory"

