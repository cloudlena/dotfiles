xet r rate 140 50
setxkbmap -option caps:escape

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

exec bspwm
