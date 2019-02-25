#!/bin/bash

# This script installs usefull tools using brew.
# The tools are typically work related.

TOOLS=(
)

for i in ${TOOLS[@]}; do
    brew cask install ${i}
done

brew cask install --appdir="/Applications" spotify
brew cask install --appdir="/Applications" discord
brew cask install --appdir="/Applications" twitch 

