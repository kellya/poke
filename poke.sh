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
ARTICLE_PATTERN='{\%\s*if DISQUS_SITENAME\s*\%}'    # The pattern used to identify where to inject the comment code in the article
BASE_PATTERN='<\/body>'                             # The pattern used to identify where to inject the script include code in the base.html
CACTUS_SCRIPT='cactus_script.html'                  # The file that holds the cactus.chat script to inject into the base

file_patched () {
    # Check either base or article, and return 0 if the modification text has been found
    # or nonzero if the text doesn't exist
    case $1 in
        'base')
            if grep -q "$CACTUS_SCRIPT" "$BASE_HTML";then
                return 0
            else
                return 101
            fi
            ;;
        'article')
            if grep -q "CACTUS_SITENAME" "$ARTICLE_HTML"; then
                return 0
            else
                return 102
            fi
            ;;
        *)
            echo "Error file_patched not called correctly"
            return 100
            ;;
    esac
}

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
# Determine if the theme files exist and have already been patched and exit if so
if [[ -f "$BASE_HTML" ]] && [[ -f "$ARTICLE_HTML" ]]; then
    if file_patched base || file_patched article; then
        echo "It looks like this theme already has been modified"
        exit 1
    fi
else
    echo "Both base.html and article.html must exist"
    exit 3
fi
echo

########## base.html injection logic ########## 
# Attempt to do the template modifies with cactus comment stuff
# We've already checked for file existance above, so we can assume that sed'ing it will be fine at this point
echo -n "Attempting to inject the $CACTUS_SCRIPT indlude in $BASE_HTML: "
# Determine if $BASE_PATTERN is found in the base.html and thus patchable
if grep -qe "$BASE_PATTERN" "$BASE_HTML"; then
    # Search for the $BASE_PATTERN tag and inject the include before that line
    sed -ie "/^.*$BASE_PATTERN.*/i \{\% include '$CACTUS_SCRIPT' \%\}" "$BASE_HTML"
    if file_patched base; then
        echo "Success"
    else
        echo -e "Error\n$BASE_HTML did not successfully modify"
    fi
else
    echo -e "Error\nCouldn't find \"${BASE_PATTERN//\\/}\" in $BASE_HTML, you'll have to manually modify"
fi
echo

########## article.html injection logic ########## 
echo -n "Attempting to inject the comment div in $ARTICLE_HTML: "
# Search for the DISQUS_SITENAME if statement common in themes, and inject the cactus if statement before that match (sed -i)
if grep -qe "$ARTICLE_PATTERN" "$ARTICLE_HTML" && [[ $(grep -ce "$ARTICLE_PATTERN" "$ARTICLE_HTML") -eq 1 ]];then
    sed  -ie "/$ARTICLE_PATTERN/i \{\% if CACTUS_SITENAME \%\}\n\t<div id=\"comment-section\"></div>\n\{\% endif \%\}" "$ARTICLE_HTML"
    if file_patched article; then
        echo "Success"
    else
        echo -e "Error\n$ARTICLE_HTML did not successfully modify"
    fi
else
    echo -e "Error\nDISQUS_SITENAME not found (or more than 1 match) in $ARTICLE_HTML.  You'll have to manually patch"
fi
echo

########## copy cactus_script.html ##########
# Check if the cactus_script.html has already been placed in the templates dir, if not copy from wherever poke.sh was called.
if [[ -f $CACTUS_SCRIPT ]]; then
    echo "You've already got the $CACTUS_SCRIPT included, so you are good to go"
else
    echo "Copying $CACTUS_SCRIPT to this directory"
    CP_DIR=$(dirname "$0")
    cp "$CP_DIR"/$CACTUS_SCRIPT .
fi
