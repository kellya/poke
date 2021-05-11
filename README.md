# poke.sh

## What is it?
There are two parts, the first is the cactus_script.html that has all of the theme template content needed to make it work, and the poke.sh which is a shell script to automatically inject the template changes needed to make use of cactus_script.html.

You must first register a site with [cactus.chat](https://cactus.chat) (or your own host if you are self-hosting).  Then you may modify pelican templates to make use of the cactus_script.html indcluded in this repo

## pelicanconf.py variables to set

In your pelicanconf.py, you will need at least the `CACTUS_SITNAME` variable set.  If you set nothing else, this will use cactus.chat as the host.

As of version 0.9.0 of the cactus webclient, you may optionally use HTML Data
attributes to display the chat.  This is supported by setting the `CACTUS_HTML_DATA`
variable to `True`.  The default is False.

### Self-hosting

If you are self-hosting you must set the following variables

`CACTUS_SITENAME` to the site you registered with your cactuschat bot.

`CACTUS_SERVERNAME` to the base sitename (the "domain.com" part of the @user:domain.com of your user IDs)

`CACTUS_HOMESERVER` to the URL of your homeserver

You may also choose to self-host the JavaScript and CSS parts.  In order to specify those URLs you would set `CACTUS_JS_URL` and `CACTUS_CSS_URL` respectively

### Optional Settings

`CACTUS_LOGIN_ENABLED` (true or false) Boolean to allow/disallow client logins
directly (true) or via a matrix.to link (false).
`CACTUS_PAGE_SIZE` (integer) A number for the number of comments to show per page
`CACTUS_GUEST_POSTING` (true or false) Boolean to allow/disallow guest posting
`CACTUS_UPDATE_INTERVAL` (integer) The number of seconds to auto-refresh the
comments.  Zero or negative number disabled
`CACTUS_HTML_DATA` (true or false) Option to display chat via HTML data
attributes (true) or not (**false**)

## Article metadata variables

You may disable chat integration on a single page by setting ``cactus_chat_disable`` to ``True`` in the article metadata.  The details for setting metadata varies depending on the document source, see [Pelican's documentation](https://docs.getpelican.com/en/4.5.4/content.html) for specifics.

You may override the cactus chat section ID with ``cactus_comment_section_id`` in the metadata.  This allows you to optionally use the same chat for multiple pages, or to override the default name for things like fixing the difference in automatic generation from version 1 to 2 of poke.  See section below.

### RestructuredText

Metadata in RestructuredText is specified at the top of the file, wrapped in colons:
``:cactus_chat_disable: True``

### Markdown

Markdown similarly sets metadata at the top of the file.  To disable chat in MarkDown source files:
``cactus_chat_disable: True``

## How does it work?

Poke.sh assumes that the theme you are modifying already has a block for Disqus chatting.  It uses this as an anchor to figure out where to inject cactus.chat
If the theme templates don't include Disqus, then you'll have to manually do it.

It uses the `{{article.slug}}` template variable to create a unique comment section for each page.  Whatever your pelican outputs as page.html will be the address generated for each post.  Typically that would be the title of the page, or the slug.  So if you have a page with the title "this is a test", the cactus_script.html will generate a room id like `#comments_your.domain_this-is-a-test:yourhomeserver.domain`

This also means that it is possible to set the ``slug`` metadata in your file to control the output, if you wish for it to differ from the page title.

## How do I use this?

1. Clone the repo to your location of choice
2. go to the templates directory of the theme you wish to modify: `cd /path/to/your/pelican/theme/templates`
3. Run the poke.sh command from this directory with `/path/to/poke.sh`.

Assuming there is an article.html, it will be modified and the cactus_script.html will be copied into the templates.

## The script didn't work, how do I do this manually?

If poke.sh worked, you shouldn't need to read this section, but if something went wrong (or you don't trust my 5 minutes of hacking sed to do this), here are the manual steps you can try:

1. Copy the cactus_script.html to the templates directory
2. Modify the article.html and add the following at the bottom of the html, but before the {% endblock %}

    `{% include "cactus_script.html" %}`

3. Modify the article.html and put the following at the location at which you want the comments to show up in the page
    ```
    {% if CACTUS_SITENAME %}
        {% if not article.metadata['cactus_chat_disable'] %}
            <div id="comment-section"></div>
        {% else %}
            <p> Chat has been disabled for this post </p>
        {% endif %}
    {% endif %}
    ```
## Poke update from version 1 to 2

The big difference between poke version 1 and 2 is that all the content is now included directly in the article.html.  This was done to get access to the article objects (namely the metadata fields for the new overrides), but because it now has access to the 'article.slug' object, I thought that made a better section identifier.  That means that any pages generated on poke v1.x will have to be manually overridden to have the old name specified in ``cactus_comment_section_id`` in the metadata of the source files.

## Feedback/contact

For any feedback, or issues  please use the [issues](https://github.com/kellya/poke/issues) page.

If you would like to communicate via Matrix, you may join poke project room at [#poke:arachnitech.com](https://matrix.to/#/#poke:arachnitech.com)
