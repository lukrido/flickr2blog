#!/bin/bash

echo "- Getting tabs"
osascript "./GetFlickrTabs.scpt" > /dev/null

if [[ -s $HOME/Desktop/flickrtabs.txt ]] ; then
	echo "- Processing tabs"
	# reads flickrtabs.txt
	./buildBlogPostFromFlickr.py
fi

if [ -e $HOME/Desktop/flickrtabs.txt ]; then
	echo "- Removing flicktabs.txt"
	#rm $HOME/Desktop/flickrtabs.txt
fi

if [[ -s $HOME/Desktop/blog.txt ]] ; then
	# reads blog.txt
	echo "- Patching blog file"
	./patchblog.pl $HOME/Desktop/blog.txt

open -a TextEdit $HOME/Desktop/blog.txt
else
	echo "- No pictures to process"
	exit 1
fi
