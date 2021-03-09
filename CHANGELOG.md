v2.0.1 / 2021-03-09
===================

  * fix: changed metadata for section id to more closely match what it actually is in the cactus_script

v2.0.0 / 2021-03-09
===================

  * doc: update documentation for the version 2 changes
  * doc: updated readme to include the additional cactus_section_id metadata
  * Rewrote to modify only article, and utilize article jinja objects

v1.0.3 / 2021-03-09
===================

  * Updated changelog
  * Added metadata examples
  * Added metadata section for the chat disabling details
  * fix: spelling error in variable check
  * feat: Disable chat inclusion on a single article
  * fixed the issue link, which was itself an issue
  * Added matrix link to readme

v1.0.2 / 2021-03-04
===================

  * fix: show $BASE_HTML and $ARTICLE_HTML in message output
  * Initial generation of CHANGELOG
  * fix: Moved copy to the first operation and added error checking for a copy fail

v1.0.1 / 2021-03-04
===================

  * Moved copy to the first operation and added error checking for a copy fail

v1.0.0 / 2021-03-03
===================

  * Added the pattern to the article error
  * Added the output_file template details
  * Added  to error output, and an extra echo between sections to help readability of output
  * moved cactus_script.html to a variable
  * Moved patterns to variables and added additional sanity checks before patching
  * Added more verification and feedback for the patching process
  * Added check to verify template files exist and corrected logic error determining if patch was alread applied
  * Narrowed regex a little more
  * The match was a little too greedy and wreaked havoc on one template I tried.
  * removed the 'not' from the grep line, that was causing an inverted check
  * shellcheck fixes
  * spelling
  * Some theme/template clarification and it's template(s) not template ;)
  * do, not to
  * md line formatting
  * Fixed bad md link
  * Initial commit
