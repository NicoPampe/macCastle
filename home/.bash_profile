if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# Terminal settings
alias gs='git status'
g() { "$(which git)" "$@" ;}
alias lint="git status | sed -n -e 's%^.*modified:   %./%p' | grep '.php$' | xargs -n1 php -l"
export PATH=~/bin:$PATH
# TODO: get vault set up
# export PATH="$PATH:/Users/nicholas.pampe/Documents/vault"
eval $(thefuck --alias)
alias gp='git pull origin $parse_git_branch && git push origin $parse_git_branch'
alias bs='. ~/.bash_profile'
alias cr='clear'
alias kt='source ~/foxden-infrastructure/k8s/scripts/ktools.sh -p'
alias nodeInstallClean='rm -rf node_modules/ && npm install'

export HOMESHICK_DIR=/usr/local/opt/homeshick
source "/usr/local/opt/homeshick/homeshick.sh"
source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# Make the termial pretty. Probably a better option
# export PS1="\[\e[4;33m[\u@\h \W]\$ \e[m\] "

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

sauce() {
	if [ -z $1 ]; then
		echo "Usage: sauce <bool for export SAUCE>"
		return 1
	fi

	if $1; then
		export SAUCE_USERNAME
		export SAUCE_ACCESS_KEY
		echo "Set the SAUCE info"
	else
		unset SAUCE_USERNAME
		unset SAUCE_ACCESS_KEY
		echo "Unset SAUCE info. Will run locally"
	fi
}

# k8s
cluster() {
	if [ -z $1 ]; then
		echo "Usage: cluster <number>"
		return 1
	fi

	aws ecovate
	if [ "$1" == "dam" ]; then
		echo "Using the dam credentials"
		export KOPS_NAME="dam.cluster.foxden.io"
		export KOPS_STATE_STORE="s3://foxden-k8s-cluster-state"
		kops export kubecfg --name $KOPS_NAME
		kubectl config use-context $KOPS_NAME
		kubectl config set-context $(kubectl config current-context) --namespace=foxden
	elif [ "$1" == "hive" ]; then
		echo "Using the hive credentials"
		export KOPS_NAME="hive.cluster.foxden.io"
		export KOPS_STATE_STORE="s3://foxden-k8s-cluster-state"
		kops export kubecfg --name $KOPS_NAME
		kubectl config use-context $KOPS_NAME
		kubectl config set-context $(kubectl config current-context) --namespace=foxden
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

# finally, set up any last settings
aws_swtich foxden
kt

# TODO: vault
# complete -C /Applications/vault vault

# Finally.... whats on my list?
todolist list
