# poke.sh

## What is it?
There are two parts, the first is the cactus_script.html that has all of the theme template content needed to make it work, and the poke.sh which is a shell script to automatically inject the template changes needed to make use of cactus_script.html.

You must first register a site with [cactus.chat](https://cactus.chat) (or your own host if you are self-hosting).  Then you may modify pelican templates to make use of the cactus_script.html indcluded in this repo

## pelicanconf.py variables to set

In your pelicanconf.py, you will need at least the `CACTUS_SITNAME` variable set.  If you set nothing else, this will use cactus.chat as the host.

### Self-hosting

If you are self-hosting you must set the following variables

`CACTUS_SITENAME` to the site you registered with your cactuschat bot.

`CACTUS_SERVERNAME` to the base sitename (the "domain.com" part of the @user:domain.com of your user IDs)

`CACTUS_HOMESERVER` to the URL of your homeserver

You may also choose to self-host the JavaScript and CSS parts.  In order to specify those URLs you would set `CACTUS_JS_URL` and `CACTUS_CSS_URL` respectively

## How does it work?

Poke.sh assumes that the theme you are modifying already has a block for Disqus chatting.  It uses this as an anchor to figure out where to inject cactus.chat
If the theme templates don't include Disqus, then you'll have to manually do it.

It uses the `{{output_file}}` template variable to create a unique comment section for each page.  Whatever your pelican outputs as page.html will be the address generated for each post.  Typically that would be the title of the page, or the slug.  So if you have a page with the title "this is a test", that will create 'output/this-is-a-test.html'.  The cactus_script.html will generate a room id like `#comments_your.domain_this-is-a-test.html:yourhomeserver.domain`

## How do I use this?

1. Clone the repo to your location of choice
2. go to the templates directory of the theme you wish to modify: `cd /path/to/your/pelican/theme/templates`
3. Run the poke.sh command from this directory with `/path/to/poke.sh`.

Assuming there is a base.html and an article.html, they will be modified and the cactus_script.html will be copied into the templates.

## The script didn't work, how do I do this manually?

If poke.sh worked, you shouldn't need to read this section, but if something went wrong (or you don't trust my 5 minutes of hacking sed to do this), here are the manual steps you can try:

1. Copy the cactus_script.html to the templates directory
2. Modify the base.html and add the following at the bottom of the html, but before the `</body>`

    `{% include "cactus_script.html" %}`

3. Modify the article.html and put the following at the location at which you want the comments to show up in the page
    ```
    {% if CACTUS_SITENAME %}
	<div id="comment-section"></div>
    {% endif %}
    ```
## Feedback/contact

For any feedback, please use the [issues](issues) page.

If you would like to communicate via Matrix, you may join the [poke project room](https://matrix.to/#/#poke:arachnitech.com)
