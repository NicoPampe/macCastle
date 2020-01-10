#!/bin/bash

# This script installs the high level tools used by other scripts and base tools

# First: get brew. Used for most all other steps
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Second: install all other base tool
TOOLS=(
    git
    node
    wget
    bash-completion
    homeshick
)

for i in ${TOOLS[@]}; do
    brew install ${i}
done

