#!/bin/sh

set -o errexit
set -o nounset
# set -o xtrace

# Check if the script is running on a CI
CI_WORKSPACE=${CI_WORKSPACE:-}
# Use the CI workspace if defined to use the code trat triggered the CI workflow
LOCAL_PATH=${CI_WORKSPACE:-${HOME}/.ansible/dotfiles}
PROFILE=${PROFILE:-all}
REPOSITORY="https://github.com/davidmogar/dotfiles.git"
TAGS=${TAGS:-all}

check_release() {
  info "Checking Linux version..."
  if command_exists lsb_release; then
    if [ "Ubuntu" = $(lsb_release -is) ]; then
      RELEASE=$(lsb_release -rs)
    fi
  else
    if grep -q "DISTRIB_ID=Ubuntu" /etc/*-release; then
      RELEASE=$(grep DISTRIB_RELEASE /etc/*-release | cut -d "=" -f2)
    fi
  fi

  if [ "${RELEASE+set}" = set ]; then
    info "Running on Ubuntu ${RELEASE}"
  else
    error "Ubuntu is required to use this Ansible playbook"
  fi
}

clone_repository() {
  if [ -n "$CI_WORKSPACE" ]; then
    warning "Running on a CI workflow. Skipping clonning..."
  else
    if [ -d ${LOCAL_PATH} ]; then
      warning "Old installation found. Deleting..."
      rm -rf ${LOCAL_PATH}
    fi

    info "Clonning repository into '${LOCAL_PATH}'..."
    mkdir -p $LOCAL_PATH
    git clone $REPOSITORY $LOCAL_PATH
  fi
}

command_exists() {
	command -v "$@" >/dev/null 2>&1
}

error() {
	echo ${RED}"Error: $@"${RESET} >&2; exit
}

info() {
  echo ${GREEN}"$@"${RESET} >&2
}

install_requirements() {
  info "Installing required packages..."
  sudo apt-get update

  if ! grep -q "ansible/ansible" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    info "Adding Ansible PPA..."
    sudo apt-get -y install software-properties-common
    sudo apt-add-repository -y ppa:ansible/ansible
  fi

  sudo apt-get -yqq install ansible git
}

run_playbook() {
  info "Running playbook..."
  cd $LOCAL_PATH
  ansible-playbook -i inventory playbook.yml --diff --limit $PROFILE --tags $TAGS --ask-become-pass
}

setup_color() {
	# Only use colors if connected to a terminal
	if [ -t 1 ]; then
		GREEN=$(printf '\033[32m')
    RED=$(printf '\033[31m')
		RESET=$(printf '\033[m')
		YELLOW=$(printf '\033[33m')
	else
		GREEN=""; RED=""; RESET=""; YELLOW=""
	fi
}

warning() {
  echo ${YELLOW}"Warning: $@"${RESET} >&2
}

main() {
  setup_color
  check_release
  install_requirements
  clone_repository
  run_playbook
}

main "$@"
