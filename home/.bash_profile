if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# Terminal settings
g() { "$(which git)" "$@" ;}
export PATH=~/bin:$PATH
PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
eval $(thefuck --alias)
alias gs='git status'
alias gp='git pull origin $parse_git_branch && git push origin $parse_git_branch'
alias bs='. ~/.bash_profile'
alias cr='clear'
alias nodeInstallClean='git checkout -- npm-shrinkwrap.json || true && rm -rf node_modules/ && nvm use && npm install'
alias updateGlobalGitIgnore='git config --global core.excludesfile ~/.gitignore_global'

export HOMESHICK_DIR=/usr/local/opt/homeshick
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

export HOMEBREW_GITHUB_API_TOKEN=$HOMEBREW_GITHUB_API_TOKEN

# Make the termial pretty. Probably a better option
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# nvm
nvm use 12.13.0

# Passwords
source ~/.keys/keys

aws_swtich() {
	if [ -z $1 ]; then
		echo "Usage: aws <ecovate|foxden>"
		return 1
	fi

	if [ "$1" == "foxden" ]; then
		export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID_FOXDEN
		export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY_FOXDEN
	elif [ "$1" == "ecovate" ]; then
		export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID_ECOVATE
		export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY_ECOVATE
	fi
}

# git
cob() {
  if [ -z $1 ]; then
    echo "Usage: cob <pattern to match git branch>"
    echo "Switch to a git branch based on a greppable pattern. Must specify an umambiguous pattern."
    return 1
  fi

  local pattern=$1
  local branchMatches=$(g branch | grep $pattern)

  # cannot proceed with more than one match
  local numMatches=$(echo "$branchMatches" | wc -l)
  if [ $numMatches != 1 ]; then
    echo -e "${NORMAL_YELLOW}Error: ambiguous pattern. The following branches matched:${NORMAL_CLEAR}"
    echo "$branchMatches"
    return 2
  fi

  # cannot proceed with no matches; we don't want to just run `git checkout`
  if [ -z "$branchMatches" ]; then
    echo -e "${NORMAL_RED}No matching branches were found. Available branches:${NORMAL_CLEAR}"
    g branch
    return 3
  fi

  trimmedBranch=$(echo "$branchMatches" | tr -d '[:space:]')
  echo -e "${NORMAL_GREEN}Switching to branch ${trimmedBranch}${NORMAL_CLEAR}"
  g checkout $trimmedBranch
}

# Java alias
alias j9="export JAVA_HOME=`/usr/libexec/java_home -v 9`; java -version"
alias j8="export JAVA_HOME=`/usr/libexec/java_home -v 1.8`; java -version"

# set up Ombud dirs
export OMBUD_PLATFORM="/Users/nicholas.pampe/ombud"
export PATH="$PATH:$OMBUD_PLATFORM/ops/scripts"

# finally, set up any last settings

# Finally.... whats on my list?
ultralist list

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/nicholas.pampe/.sdkman"

[[ -s "/Users/nicholas.pampe/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/nicholas.pampe/.sdkman/bin/sdkman-init.sh"
