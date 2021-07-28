#!/usr/bin/env bash
accent_color='02111bff'
accent_font='Calvin and Hobbes'
right_padding=30

i3lock --nofork \
    --ring-color=00000000 \
    --inside-color=00000000 \
    --separator-color=00000000 \
    --line-color=00000000 \
    --keyhl-color=00000000 \
    --bshl-color=00000000 \
    --insidever-color=00000000 \
    --ringver-color=00000000 \
    --insidewrong-color=00000000 \
    --ringwrong-color=00000000 \
    \
    --force-clock	\
    --time-str="%H:%M" \
    --time-font="Calvin and Hobbes"	\
    --time-size=150 \
    --time-align=2 \
    --time-pos="-$right_padding + x + w:y + h - 80" \
    \
    --date-str="%A, %d %B" \
    --date-font="$accent_font" \
    --date-size=80 \
    --date-pos="tx:ty - 180" \
    --date-align=2 \
    \
    --verif-font="$accent_font"	\
    --verif-size=150 \
    --verif-text="verifying..." \
    --wrong-font="Calvin and Hobbes" \
    --wrong-size=150 \
    --wrong-text="No Entry!" \
    \
    --image="$HOME/Pictures/wallpapers/Calvin-and-Hobbes.png" \
    --fill \
    \
    --greeter-size=150 \
    --greeter-color="$accent_color" \
    --greeter-font="$accent_font" \
    --greeter-pos="-$right_padding + x + w:y + 160" \
    --greeter-align=2 \
    --greeter-text="Not today!!" \

