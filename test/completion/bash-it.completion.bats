#!/usr/bin/env bats

load ../test_helper
load ../../lib/composure
load ../../completion/available/bash-it.completion

function local_setup {
  mkdir -p "$BASH_IT"
  lib_directory="$(cd "$(dirname "$0")" && pwd)"
  # Use rsync to copy Bash-it to the temp folder
  # rsync is faster than cp, since we can exclude the large ".git" folder
  rsync -qavrKL -d --delete-excluded --exclude=.git $lib_directory/../.. "$BASH_IT"

  rm -rf "$BASH_IT"/enabled
  rm -rf "$BASH_IT"/aliases/enabled
  rm -rf "$BASH_IT"/completion/enabled
  rm -rf "$BASH_IT"/plugins/enabled

  mkdir -p "$BASH_IT"/enabled
  mkdir -p "$BASH_IT"/aliases/enabled
  mkdir -p "$BASH_IT"/completion/enabled
  mkdir -p "$BASH_IT"/plugins/enabled

  # Don't pollute the user's actual $HOME directory
  # Use a test home directory instead
  export BASH_IT_TEST_CURRENT_HOME="${HOME}"
  export BASH_IT_TEST_HOME="$(cd "${BASH_IT}/.." && pwd)/BASH_IT_TEST_HOME"
  mkdir -p "${BASH_IT_TEST_HOME}"
  export HOME="${BASH_IT_TEST_HOME}"
}

function local_teardown {
  export HOME="${BASH_IT_TEST_CURRENT_HOME}"

  rm -rf "${BASH_IT_TEST_HOME}"

  assert_equal "${BASH_IT_TEST_CURRENT_HOME}" "${HOME}"
}

@test "completion bash-it: ensure that the _bash-it-comp function is available" {
  type -a _bash-it-comp &> /dev/null
  assert_success
}

function __check_completion () {
  # Get the parameters as an array
  eval set -- "$@"
  COMP_WORDS=("$@")

  # Get the parameters as a single value
  COMP_LINE=$*

  # Index of the cursor in the line
  COMP_POINT=${#COMP_LINE}

  # Word index of the last word
  COMP_CWORD=$(( ${#COMP_WORDS[@]} - 1 ))

  # Run the Bash-it completion function
  _bash-it-comp

  # Return the completion output
  echo "${COMPREPLY[@]}"
}

@test "completion bash-it: disable - provide nothing when atom is not enabled" {
  run __check_completion 'bash-it disable alias ato'
  assert_line "0" "all"
}

@test "completion bash-it: disable - provide the a* aliases when atom is enabled with the old location and name" {
  ln -s $BASH_IT/aliases/available/atom.aliases.bash $BASH_IT/aliases/enabled/atom.aliases.bash
  assert [ -L "$BASH_IT/aliases/enabled/atom.aliases.bash" ]

  run __check_completion 'bash-it disable alias a'
  assert_line "0" "all atom"
}

@test "completion bash-it: disable - provide the a* aliases when atom is enabled with the old location and priority-based name" {
  ln -s $BASH_IT/aliases/available/atom.aliases.bash $BASH_IT/aliases/enabled/150---atom.aliases.bash
  assert [ -L "$BASH_IT/aliases/enabled/150---atom.aliases.bash" ]

  run __check_completion 'bash-it disable alias a'
  assert_line "0" "all atom"
}

@test "completion bash-it: disable - provide the a* aliases when atom is enabled with the new location and priority-based name" {
  ln -s $BASH_IT/aliases/available/atom.aliases.bash $BASH_IT/enabled/150---atom.aliases.bash
  assert [ -L "$BASH_IT/enabled/150---atom.aliases.bash" ]

  run __check_completion 'bash-it disable alias a'
  assert_line "0" "all atom"
}

@test "completion bash-it: enable - provide the atom aliases when not enabled" {
  run __check_completion 'bash-it enable alias ato'
  assert_line "0" "atom"
}

@test "completion bash-it: enable - provide the a* aliases when not enabled" {
  run __check_completion 'bash-it enable alias a'
  assert_line "0" "all ag ansible apt atom"
}

@test "completion bash-it: enable - provide the a* aliases when atom is enabled with the old location and name" {
  ln -s $BASH_IT/aliases/available/atom.aliases.bash $BASH_IT/aliases/enabled/atom.aliases.bash
  assert [ -L "$BASH_IT/aliases/enabled/atom.aliases.bash" ]

  run __check_completion 'bash-it enable alias a'
  assert_line "0" "all ag ansible apt"
}

@test "completion bash-it: enable - provide the a* aliases when atom is enabled with the old location and priority-based name" {
  ln -s $BASH_IT/aliases/available/atom.aliases.bash $BASH_IT/aliases/enabled/150---atom.aliases.bash
  assert [ -L "$BASH_IT/aliases/enabled/150---atom.aliases.bash" ]

  run __check_completion 'bash-it enable alias a'
  assert_line "0" "all ag ansible apt"
}

@test "completion bash-it: enable - provide the a* aliases when atom is enabled with the new location and priority-based name" {
  ln -s $BASH_IT/aliases/available/atom.aliases.bash $BASH_IT/enabled/150---atom.aliases.bash
  assert [ -L "$BASH_IT/enabled/150---atom.aliases.bash" ]

  run __check_completion 'bash-it enable alias a'
  assert_line "0" "all ag ansible apt"
}
