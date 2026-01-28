# Markdown Style Guide (Condensed)

## Goals
- Keep source text readable and portable.
- Keep the Markdown corpus maintainable across teams and time.
- Keep the syntax simple and easy to remember.

## Contents
- Minimum viable documentation
- Better is better than best
- Capitalization
- Document layout
- Table of contents
- Character line limit
- Trailing whitespace
- Headings
- Lists
- Code
- Links
- Images
- Tables
- Strongly prefer Markdown to HTML

## Minimum viable documentation
A small set of fresh and accurate docs is better than a sprawling assembly of
out-of-date documentation.

- Identify what you really need: release docs, API docs, testing guidelines.
- Delete cruft frequently and in small batches.

## Better is better than best
Docs review standards are different from code review standards. Reviewers
should ask for improvements, but authors should be able to invoke the
"Better/Best Rule" to keep iteration fast.

As a reviewer:
- When reasonable, LGTM immediately and trust that comments will be fixed.
- Prefer suggesting an alternative instead of vague comments.
- For substantial changes, start your own follow-up CL instead of blocking.
- Rarely, block submission if the CL makes the docs worse; ask to revert.

As an author:
- Avoid trivial arguments. Capitulate early and move on.
- Cite the Better/Best Rule as needed.

## Capitalization
Use original capitalization for product, tool, and binary names.

Good:
```markdown
# Markdown style guide

`Markdown` is a dead-simple platform for internal engineering documentation.
```

Bad:
```markdown
# markdown bad style guide example

`markdown` is a dead-simple platform for internal engineering documentation.
```

## Document layout
Most docs benefit from a common layout:

```markdown
# Document Title

Short introduction.

[TOC]

## Topic

Content.

## See also

* https://link-to-more-info
```

Guidance:
- Title: The first heading should be H1, ideally matching the filename. The
  first H1 is used as the page title.
- Author: Optional. If you want to claim ownership, add yourself under the
  title, but revision history generally suffices.
- Introduction: 1-3 sentences for a newbie. Explain what the thing is and why
  they care.
- [TOC]: If your hosting supports it, place after the introduction and before
  the first H2 heading.
- H2: Subsequent headings start at level 2.
- See also: Put miscellaneous links at the bottom.

## Table of contents
Use a [TOC] directive unless all content is above the fold on a laptop.

Place the [TOC] directive after the introduction and before the first H2:

```markdown
# My Page

This is my introduction **before** the TOC.

[TOC]

## My first H2
```

Bad placement (after the TOC):
```markdown
# My Page

[TOC]

This is my introduction **after** the TOC where it should not be.

## My first H2
```

Screen readers read the TOC where it appears in the DOM, so placement matters.

## Character line limit
Follow an 80-character line limit for Markdown.

Why:
- Tooling integration: Code Search does not soft wrap.
- Quality: Engineers already follow code formatting habits.

Exceptions:
- Links
- Tables
- Headings
- Code blocks

Lines containing links may exceed 80 chars, but wrap surrounding text:
```markdown
*   See the
    [foo docs](https://gerrit.googlesource.com/gitiles/+/HEAD/Documentation/markdown.md).
    and find the logfile.
```

Tables may also run long. Prefer short, readable tables.

## Trailing whitespace
Do not use trailing whitespace. Use a trailing backslash to force a line break.

The CommonMark spec allows two trailing spaces for a line break, but many repos
strip trailing whitespace.

Use a trailing backslash sparingly:
```markdown
For some reason I just really want a break here,\
though it's probably not necessary.
```

Prefer paragraphs over forced line breaks.

## Headings

### ATX-style headings
Use #, not underlines:

Good:
```markdown
# Heading 1

## Heading 2
```

Bad:
```markdown
Heading - do you remember what level? DO NOT DO THIS.
---------
```

### Use unique, complete names for headings
Use descriptive and unique headings so anchors are meaningful.

Prefer:
```markdown
## Foo
### Foo summary
### Foo example
## Bar
### Bar summary
### Bar example
```

Avoid:
```markdown
## Foo
### Summary
### Example
## Bar
### Summary
### Example
```

### Add spacing to headings
Add a space after # and blank lines before/after headings:

Good:
```markdown
...text before.

## Heading 2

Text after...
```

Bad:
```markdown
...text before.

##Heading 2
Text after... DO NOT DO THIS.
```

### Use a single H1 heading
Use one H1 heading as the title. Subsequent headings should be H2 or deeper.

### Capitalization of titles and headers
Follow the Google Developer Documentation Style Guide for capitalization.

## Lists

### Use lazy numbering for long lists
Markdown renders lists correctly, so use lazy numbering for long or nested
lists that change often:

```markdown
1.  Foo.
1.  Bar.
    1.  Foofoo.
    1.  Barbar.
1.  Baz.
```

For short, stable lists, use fully numbered lists:
```markdown
1.  Foo.
2.  Bar.
3.  Baz.
```

### Nested list spacing
Use 4-space indentation for nested lists and wrapped text.

Numbered list:
```markdown
1.  Use 2 spaces after the item number, so the text is indented 4 spaces.
    Use a 4-space indent for wrapped text.
2.  Use 2 spaces again for the next item.
```

Bulleted list with nesting:
```markdown
*   Use 3 spaces after a bullet, so the text is indented 4 spaces.
    Use a 4-space indent for wrapped text.
    1.  Use 2 spaces with numbered lists, as before.
        Wrapped text in a nested list needs an 8-space indent.
    2.  Looks nice, doesn't it?
*   Back to the bulleted list, indented 3 spaces.
```

Messy example (avoid):
```markdown
* One space,
with no indent for wrapped text.
     1. Irregular nesting... DO NOT DO THIS.
```

Even without nesting, 4-space indent keeps layout consistent:
```markdown
*   Foo,
    wrapped with a 4-space indent.

1.  Two spaces for the list item
    and 4 spaces before wrapped text.
2.  Back to 2 spaces.
```

For small, single-line lists, a single space is acceptable:
```markdown
* Foo
* Bar
* Baz.

1. Foo.
2. Bar.
```

## Code

### Inline
Use backticks for short code, field names, and commands:

```markdown
You'll want to run `really_cool_script.sh arg`.

Pay attention to the `foo_bar_whammy` field in that table.
```

Use inline code for file types in a generic sense:
```markdown
Be sure to update your `README.md`!
```

#### Use code span for escaping
Wrap text in backticks when you do not want Markdown processing:

```markdown
An example Markdown shortlink would be: `Markdown/foo/Markdown/bar.md`

An example query might be: `https://www.google.com/search?q=$TERM`
```

### Codeblocks
Use fenced code blocks for multi-line code:

```python
def Foo(self, bar):
  self.bar = bar
```

#### Declare the language
Always specify the language when possible for syntax highlighting.

#### Escape newlines
Command-line snippets should be copy/paste friendly; escape newlines:

```shell
$ bazel run :target -- --flag --foo=longlonglonglonglongvalue \
  --bar=anotherlonglonglonglonglonglonglonglonglonglongvalue
```

#### Use fenced code blocks instead of indented code blocks
Indented blocks are ambiguous and cannot declare a language. Avoid them.

Bad:
```markdown
You'll need to run:

    bazel run :thing -- --foo

And then:

    bazel run :another_thing -- --bar
```

#### Nest codeblocks within lists
Indent fenced code blocks to keep list structure intact:

````markdown
*   Bullet.

    ```c++
    int foo;
    ```

*   Next bullet.
````

You can also indent by 4 spaces to nest a code block inside a list:

```markdown
*   Bullet.

        int foo;

*   Next bullet.
```

## Links
Long links make source Markdown hard to read. Shorten when possible.

### Use explicit paths for links within Markdown
Use explicit paths in Markdown links:

```markdown
[...](/path/to/other/markdown/page.md)
```

Avoid full URLs when a path is sufficient:
```markdown
[...](https://bad-full-url.example.com/path/to/other/markdown/page.md)
```

### Avoid relative paths unless within the same directory
Relative links are fine in the same directory:

```markdown
[...](other-page-in-same-dir.md)
```

Prefer explicit paths for other directories:
```markdown
[...](/path/to/another/dir/other-page.md)
```

Avoid relative links with ../:
```markdown
[...](../../bad/path/to/another/dir/other-page.md)
```

### Use informative Markdown link titles
Avoid "here" or "link" as anchor text.

Bad:
```markdown
See the Markdown guide for more info: [link](markdown.md), or check out the
style guide [here](/styleguide/docguide/style.html).

Check out a typical test result:
[https://example.com/foo/bar](https://example.com/foo/bar).
```

Good:
```markdown
See the [Markdown guide](markdown.md) for more info, or check out the
[style guide](/styleguide/docguide/style.html).

Check out a
[typical test result](https://example.com/foo/bar).
```

### Reference links
Use reference links when inline URLs would harm readability.

Example:
```markdown
See the [Markdown style guide][style], which has suggestions for making docs
more readable.

[style]: http://Markdown/corp/Markdown/docs/reference/style.md
```

#### Use reference links for long links
Avoid reference links when the link is short and does not disrupt flow.

Bad:
```markdown
The [style guide][style_guide] says not to use reference links unless you have
to.

[style_guide]: https://google.com/Markdown-style
```

Instead, inline short links:
```markdown
https://google.com/Markdown-style says not to use reference links unless you
have to.
```

Use reference links when the link is long enough to be distracting:
```markdown
The [style guide] says not to use reference links unless you have to.

[style guide]: https://docs.google.com/document/d/13HQBxfhCwx8lVRuN2Wf6poqvAfVeEXmFVcawP5I6B3c/edit
```

Use reference links more often in tables to keep line lengths manageable.

Bad:
```markdown
Site                                                             | Description
---------------------------------------------------------------- | -----------------------
[site 1](http://google.com/excessively/long/path/example_site_1) | This is example site 1.
[site 2](http://google.com/excessively/long/path/example_site_2) | This is example site 2.
```

Good:
```markdown
Site     | Description
-------- | -----------------------
[site 1] | This is example site 1.
[site 2] | This is example site 2.

[site 1]: http://google.com/excessively/long/path/example_site_1
[site 2]: http://google.com/excessively/long/path/example_site_2
```

#### Use reference links to reduce duplication
If a link destination appears multiple times, use a reference link to avoid
repeating long URLs.

#### Define reference links after their first use
Place reference link definitions just before the next heading in the section
where they are first used. For links used in multiple sections, place the
definition at the end of the document.

Bad:
```markdown
# Header FOR A BAD DOCUMENT

Some text with a [link][link_def].

Some more text with the same [link][link_def].

## Header 2

... lots of text ...

## Header 3

Some more text using a [different_link][different_link_def].

[link_def]: http://reallyreallyreallylonglink.com
[different_link_def]: http://differentreallyreallylonglink.com
```

Good:
```markdown
# Header

Some text with a [link][link_def].

Some more text with the same [link][link_def].

[link_def]: http://reallyreallyreallylonglink.com

## Header 2

... lots of text ...

## Header 3

Some more text using a [different_link][different_link_def].

[different_link_def]: http://differentreallyreallylonglink.com
```

## Images
Use images sparingly and prefer simple screenshots. Use images only when it is
faster to show than to describe.

Always include appropriate alt text so non-sighted readers can understand the
content. See image syntax as needed.

## Tables
Use tables for tabular data that must be scanned quickly.

Avoid tables when a list would do. Tables should be concise and balanced.

Bad:
```markdown
Fruit  | Metrics      | Grows on | Acute curvature    | Attributes                                                                                                  | Notes
------ | ------------ | -------- | ------------------ | ----------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------
Apple  | Very popular | Trees    |                    | [Juicy](http://cs/SomeReallyReallyReallyReallyReallyReallyReallyReallyLongQuery), Firm, Sweet               | Apples keep doctors away.
Banana | Very popular | Trees    | 16 degrees average | [Convenient](http://cs/SomeDifferentReallyReallyReallyReallyReallyReallyReallyReallyLongQuery), Soft, Sweet | Contrary to popular belief, most apes prefer mangoes. Don't you? See the [design doc][banana_v2] for the newest hotness in bananiels.
```

The table above has poor distribution, unbalanced dimensions, and rambling
prose in cells.

List alternative:
```markdown
## Fruits

Both types are highly popular, sweet, and grow on trees.

### Apple

*   [Juicy](http://SomeReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyLongURL)
*   Firm

Apples keep doctors away.

### Banana

*   [Convenient](http://cs/SomeDifferentReallyReallyReallyReallyReallyReallyReallyReallyLongQuery)
*   Soft
*   16 degrees average acute curvature.

Contrary to popular belief, most apes prefer mangoes. Don't you?

See the [design doc][banana_v2] for the newest hotness in bananiels.
```

When tables are the best choice (uniform data distribution, many parallel
items), keep them compact:

```markdown
Transport        | Favored by     | Advantages
---------------- | -------------- | -----------------------------------------------
Swallow          | Coconuts       | [Fast when unladen][airspeed]
Bicycle          | Miss Gulch     | [Weatherproof][tornado_proofing]
X-34 landspeeder | Whiny farmboys | [Cheap][tosche_station] since the XP-38 came out

[airspeed]: http://google3/airspeed.h
[tornado_proofing]: http://google3/kansas/
[tosche_station]: http://google3/power_converter.h
```

## Strongly prefer Markdown to HTML
Prefer standard Markdown syntax and avoid HTML hacks. If you cannot accomplish
something with Markdown, reconsider whether you need it. Gitiles does not
render HTML.

Footnote: Content is "above the fold" if visible without scrolling on a laptop
screen. Content is "below the fold" if hidden until the user scrolls or if a
print document is literally folded.
