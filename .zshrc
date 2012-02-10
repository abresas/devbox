# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/abresas/.zshrc'

autoload -Uz compinit
compinit

autoload colors; colors
export PS1="%{$fg[yellow]%}%m:%{$fg[white]%}%n %{$reset_color%}% $ "
# End of lines added by compinstall
