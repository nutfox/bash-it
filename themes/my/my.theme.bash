#!/bin/bash

VIRTUALENV_THEME_PROMPT_PREFIX='(virtualenv '
VIRTUALENV_THEME_PROMPT_SUFFIX=')'

prompt_setter() {
  # Save history
  history -a
  history -c
  history -r
  PS1="(\t) $(scm_char) [${blue}\u${reset_color}@${green}\H${reset_color}] ${yellow}\w${reset_color}$(scm_prompt_info) $(virtualenv_prompt)${reset_color}\n${green}→${reset_color} "
  PS2='> '
  PS4='+ '
}

PROMPT_COMMAND=prompt_setter

SCM_THEME_PROMPT_DIRTY=" ✗"
SCM_THEME_PROMPT_CLEAN=" ✓"
SCM_THEME_PROMPT_PREFIX=" ("
SCM_THEME_PROMPT_SUFFIX=")"
RVM_THEME_PROMPT_PREFIX=" ("
RVM_THEME_PROMPT_SUFFIX=")"
