export PS1='$ '
if [ -d $HOME/.ssh ]
then
	eval $(ssh-agent | grep -v ^echo)
	ssh-add -q
fi
