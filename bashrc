export PROMPT_COMMAND="if [ \$? = 0 ]; then DOLLAR_COLOUR=\"\033[0m\"; else DOLLAR_COLOUR=\"\033[0;31m\"; fi"
export PS1='\033[38;5;37m- $(pwd) -\n\[\033[0m\]$(echo -ne $DOLLAR_COLOUR)$\[\033[0m\] '
if [ -e $HOME/.ssh/id_ed25519 ]
then
	eval $(ssh-agent | grep -v ^echo)
	ssh-add -q
fi
