#!/usr/bin/env bash

# This is the GDK one line installation. For more information, please visit:
# https://gitlab.com/gitlab-org/gitlab-development-kit/-/blob/main/doc/index.md#one-line-installation
#
# Wrap everything in a function to ensure a partially downloaded install script
# is not executed. Inspired by https://install.sandstorm.io/
#
# Valid args are:
#
# 1 = directory in which to clone into, default is gitlab-development-kit (GDK_INSTALL_DIR)
# 2 = git SHA/branch to checkout once cloned, default is main (GDK_CLONE_BRANCH)
_() {

set -eo pipefail

DEFAULT_GDK_INSTALL_DIR="gitlab-development-kit"
DEFAULT_GITLAB_REPO_URL="https://gitlab.com/gitlab-community/gitlab.git"
DEFAULT_GDK_REPO_URL="https://gitlab.com/gitlab-org/gitlab-development-kit.git"
CURRENT_ASDF_DIR="${ASDF_DIR:-${HOME}/.asdf}"
ASDF_SH_PATH="${CURRENT_ASDF_DIR}/asdf.sh"
ASDF_FISH_PATH="${CURRENT_ASDF_DIR}/asdf.fish"
ASDF_ELVISH_PATH="${CURRENT_ASDF_DIR}/asdf.elv"
ASDF_NUSHELL_PATH="${CURRENT_ASDF_DIR}/asdf.nu"

REQUIRED_COMMANDS=(git make)

error() {
  echo "ERROR: ${1}" >&2
  exit 1
}

ensure_required_commands_exist() {
  for command in "${REQUIRED_COMMANDS[@]}"; do
    if ! command -v "${command}" > /dev/null 2>&1; then
      error "Please ensure ${command} is installed."
    fi
  done
}

ensure_not_root() {
  if [[ ${EUID} -eq 0 ]]; then
    return 1
  fi

  return 0
}

clone_gdk_if_needed() {
  if [[ -d ${GDK_INSTALL_DIR} ]]; then
    echo "INFO: A ${GDK_INSTALL_DIR} directory already exists in the current working directory, resuming.."
  else
    git clone "${GDK_REPO_URL}" "${GDK_INSTALL_DIR}"
  fi
}

ensure_gdk_clone_branch_checked_out() {
  git -C "${PWD}/${GDK_INSTALL_DIR}" fetch origin "${GDK_CLONE_BRANCH}"
  git -C "${PWD}/${GDK_INSTALL_DIR}" checkout "${GDK_CLONE_BRANCH}"
}

bootstrap() {
  make bootstrap
}

gdk_install() {
  # shellcheck disable=SC1090
  source "${ASDF_SH_PATH}"
  gdk install gitlab_repo="$GITLAB_REPO_URL" telemetry_user="$GITLAB_USERNAME"
}

echo
echo "INFO: This is the GDK one line installation. For more information, please visit:"
echo "INFO: https://gitlab.com/gitlab-org/gitlab-development-kit/-/blob/main/doc/index.md#one-line-installation"
echo "INFO:"
echo "INFO: The source for the installation script can be viewed at:"
echo "INFO: https://gitlab.com/gitlab-org/gitlab-development-kit/-/blob/main/support/install"
echo


GDK_INSTALL_DIR="${2-gitlab-development-kit}"
GDK_CLONE_BRANCH="${3-main}"

GDK_INSTALL_DIR=${GDK_INSTALL_DIR:-${DEFAULT_GDK_INSTALL_DIR}}
GDK_CLONE_BRANCH=${GDK_CLONE_BRANCH:-main}
GITLAB_REPO_URL=${GITLAB_REPO_URL:-${DEFAULT_GITLAB_REPO_URL}}
GDK_REPO_URL=${GDK_REPO_URL:-${DEFAULT_GDK_REPO_URL}}

if ! ensure_not_root; then
  error "Running as root is not supported."
fi

ensure_required_commands_exist
clone_gdk_if_needed
ensure_gdk_clone_branch_checked_out
cd "${GDK_INSTALL_DIR}" || exit
bootstrap
gdk_install

echo

echo "INFO: To make sure GDK commands are available in this shell, please run the command corresponding to your shell."
echo
echo "sh / bash / zsh:"
echo "source \"${ASDF_SH_PATH}\""
echo
echo "fish:"
echo "source \"${ASDF_FISH_PATH}\""
echo
echo "elvish:"
echo "source \"${ASDF_ELVISH_PATH}\""
echo
echo "nushell:"
echo "source \"${ASDF_NUSHELL_PATH}\""

echo
echo "INFO: To ensure you're in the newly installed GDK directory, please run:"
echo "cd ${GDK_INSTALL_DIR}"
echo
}

# If we've reached here, the entire install script has been downloaded and
# "should" be safe to execute.
_ "$0" "$@"
