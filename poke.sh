#!/bin/bash
# This attmpts to use sed to cram in the theme modifications to include cactus chat.
# This also assumes the template already includes a block for DISQUS, and puts the cactus chat include before that
# If your theme doesn't include that, you'll have to manually add the indclude.
#
# How do I run this?
# 1. cd to your pelican theme's template directory
# 2. execute /path/to/poke.sh <base.html> <article.html>
# and the script should do the rest.
# If you do not specify base.html and article.html in the command, it will default to those, which is probably what you want
# If for some reason your theme has different names for those files, specify them in the argumenst with the first being base and second being article

# Figure out what arguments were given.  If we were given none, assume base.html and article.html,
# otherwise we need two, one for base and one for article, in that order
if [[ $# -eq 0 ]]; then
    echo "Arguments not specified, assuming base.html and article.html"
    BASE_HTML='base.html'
    ARTICLE_HTML='article.html'
elif [[ $# -lt 2 ]]; then
    echo "You must specify both base and article filenames (or none if you wish to default to base.html and article.html"
    exit 2
else
    BASE_HTML=$1
    ARTICLE_HTML=$2
fi

# Determine if the theme has already been patched and exit if so
grep -q "CACTUS_SITENAME" $BASE_HTML $ARTICLE_HTML
if [ $? -eq 0 ]; then
    echo "It looks like this theme already has been modified"
    exit 1
fi

# Attempt to do the template modifies with cactus comment stuff
echo "Attempting to inject the cactus_script.html indlude in $BASE_HTML"
sed -i '/^.*<\/body>.*/i \{\% include "cactus_script.html" \%\}' $BASE_HTML
echo "Attempting to inject the comment div in $ARTICLE_HTML"
sed  -ie '/^.*if DISQUS_SITENAME.*/i \{\% if CACTUS_SITENAME \%\}\n\t<div id="comment-section"></div>\n\{\% endif \%\}' $ARTICLE_HTML

# Check if the cactus_script.html has already been placed in the templates dir, if not copy from wherever poke.sh was called.
if [[ -f cactus_script.html ]]; then
    echo "You've already got the cactus_script.html included, so you are good to go"
else
    echo "Copying cactus_script.html to this directory"
    CP_DIR=$(dirname $0)
    cp $CP_DIR/cactus_script.html .
fi
