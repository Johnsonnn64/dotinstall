#!/bin/sh
urlregex="(((http|https)://|www\\.)[a-zA-Z0-9.]*[:]?[a-zA-Z0-9./@$&%?$\#=_~-]*)|((magnet:\\?xt=urn:btih:)[a-zA-Z0-9]*)"

# First remove linebreaks and mutt sidebars:
urls="$(sed 's/.*│//g' | tr -d '\n' |
	grep -aEo "$urlregex" | # grep only urls as defined above.
	uniq | # Ignore neighboring duplicates.
	sed 's/^www./https:\/\/www\./g')"

[ -z "$urls" ] && exit

echo "$urls" | dmenu -i -p 'Follow which url?' -l 10 | xclip -selection clipboard
