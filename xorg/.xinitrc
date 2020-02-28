# Speed up key repeat
xet r rate 140 30

# Map caps lock to escape
setxkbmap -option caps:escape

# Use right alt as compose key to create umlauts
# To actually create them, type the following keys in a sequence:
# ralt + " + u --> ü
setxkbmap -option compose:ralt

# Load Xresources file
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# Import display environment variable for Dunst to work properly
systemctl --user import-environment DISPLAY

# Set wallpaper
nitrogen --restore &

# Hide cursor when not used
unclutter &

# Adjust color temperature to reduce eye strain
redshift -l '46.94:7.46' &

# Start window manager
exec bspwm
