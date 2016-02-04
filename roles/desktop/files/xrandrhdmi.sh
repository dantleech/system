#!/usr/bin/env bash

xrandr --output VGA1 --off
xrandr --output HDMI1 --auto --left-of LVDS1 --rotate left
