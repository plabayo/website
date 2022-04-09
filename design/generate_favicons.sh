#!/bin/bash

/Applications/Inkscape.app/Contents/MacOS/inkscape ./favicon.svg --export-width=32 --export-filename="./favicon.png"
convert ./favicon.png ./favicon.ico
rm ./favicon.png

/Applications/Inkscape.app/Contents/MacOS/inkscape ./favicon.svg --export-width=512 --export-filename="./icon-512.png"
/Applications/Inkscape.app/Contents/MacOS/inkscape ./favicon.svg --export-width=192 --export-filename="./icon-192.png"

cp favicon.svg favicon_opt.svg
npx svgo --multipass favicon_opt.svg

# use https://squoosh.app/ to optimize the icon-512.png
# Open your icon-512.png in Squoosh.
# Change the Compress setting to OxiPNG.
# Enable “Reduce palette”.
# Set 32 colors.
# Compare the before/after by moving the slider. If you see a difference, increase the number of colors.
# Save the file.
# Repeat these steps for icon-192.png and apple-touch-icon.png.

# apple-touch-icon.png:
# Now scale the image itself to 140×140 and set the canvas to 180×180, and then export it as apple-touch-icon.png.