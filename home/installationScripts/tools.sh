#!/bin/bash

# This script installs usefull tools using brew.
# The tools are typically work related.

CASK_TOOLS=(
    atom
    slack
    iterm2
    #google-chrome
    docker
)

for i in ${CASK_TOOLS[@]}; do
    brew cask install ${i}
done

TOOLS=(
    docker-machine
    watchman
    ultralist
    grep
    thefuck
    jq
)

for i in ${TOOLS[@]}; do
    brew install ${i}
done

# Global node modules
## https://www.npmjs.com/package/wml
npm install -g wml


# Set defaults and PATH 
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool FALSE
PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"

# Addition settings
# Atom -- sublime test's features
apm install sublime
cd ~/.atom/packages/
git clone https://github.com/idleberg/atom-sublime sublime
yarn || npm install

