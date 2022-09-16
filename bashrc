CYAN='\[\e[38;5;66m\]'
NO_COLOUR='\[\033[0m\]'
PROMPT_COMMAND="if [ \$? = 0 ]; then DOLLAR_COLOUR=\"\033[0m\"; else DOLLAR_COLOUR=\"\033[0;31m\"; fi"
PS1="$CYAN- \$(pwd) -\n$NO_COLOR\[\$(echo -ne \$DOLLAR_COLOUR)\]\$$NO_COLOR "
if [ -e $HOME/.ssh/id_ed25519 ]
then
	eval $(ssh-agent | grep -v ^echo)
	ssh-add -q
fi
