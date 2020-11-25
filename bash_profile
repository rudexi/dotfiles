# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

export PATH="$HOME/.cargo/bin:$PATH"

if [[ -s "${HOME}/.pyenv/bin/pyenv" ]] && [[ -z "${PYENV_SHELL}" ]]; then
  eval "$(pyenv init -)"
  export PYENV_ROOT="${HOME}/.pyenv"
  export PATH="${PYENV_ROOT}/bin:${PATH}"
fi
if [[ -s "${HOME}/.pyenv/bin/pyenv" ]] && [[ -z "${PYENV_VIRTUALENV_INIT}" ]]; then
  eval "$(pyenv virtualenv-init -)"
fi
if [[ -s "${HOME}/.rvm/scripts/rvm" ]] && [[ "$(type -t rvm)" != 'function' ]]; then
  source "$HOME/.rvm/scripts/rvm"
fi
if [[ -s "${HOME}/.gvm/scripts/gvm" ]] && [[ -z "${GVM_ROOT}" ]]; then
  source "${HOME}/.gvm/scripts/gvm"
fi

if [[ -s "${HOME}/.nvm/nvm.sh" ]] && [[ "$(type -t nvm)" != 'function' ]]; then
  export NVM_DIR="$HOME/.nvm"
  source "${HOME}/.nvm/nvm.sh"
  export PATH="$PATH:${NVM_BIN}"
fi

if [[ -s "$NVM_DIR/bash_completion" ]] && [[ "$(type -t __nvm_commands)" != 'function' ]]; then
  source "$NVM_DIR/bash_completion"
fi
if [[ -s "$HOME/.avn/bin/avn.sh" ]] && [[ "$(type -t __avn_find_file)" != 'function' ]]; then
  source "$HOME/.avn/bin/avn.sh"
fi

if command -v tmux >/dev/null 2>&1; then
    # if not inside a tmux session, and if no session is started, start a new session
    [ -z "${TMUX}" ] && (tmux attach >/dev/null 2>&1 || tmux)
fi
