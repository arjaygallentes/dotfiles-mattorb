#!/usr/bin/env bash
echo Installing desktop apps

set -e

source .cisupport/is_ci.sh

# Bypass upstream xattr issues with quarantine and latest OS X versions.  specifically, dropbox cask install failed
# TODO: remove me when a better solution is avail.
is_ci && export HOMEBREW_CASK_OPTS="--no-quarantine --appdir=/Applications"

brew install --cask \
    cd-to \
    keycastr \
    hammerspoon \
    whichspace \
    amethyst \
    raycast

# atreus help images
ln -sf $(pwd)/hw/atreus/kaleidoscope_with_chrysalis $HOME/.config

ln -sf $(pwd)/hammerspoon $HOME/.hammerspoon

# Yah . . . this works, svn download a sub-dir of a github repo to a dest dir
svn export --force https://github.com/mattorb/keyboard/branches/customizations/hammerspoon hammerspoon/keyboard

is_ci || osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Hammerspoon.app", hidden:true}' > /dev/null
is_ci || osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/nvALT.app", hidden:true}' > /dev/null

# Turn off Hammerspoon dock icon
defaults write org.hammerspoon.Hammerspoon MJShowDockIconKey -bool FALSE
killall Hammerspoon || true
is_ci || open /Applications/Hammerspoon.app
