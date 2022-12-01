foam-markdown-editor
--------------------

Modified version of vscode-markdown-editor and lute for foam: 
 - Support for wikilinks.

To build a release:

 `./mkvsix.sh`
 
this will build lute.min.js, install the various nodejs dependancies
and run `vsce package` which will build the extension and webview,
bundle with lute.min.js and put the .vsix into the releases directory.

You can then install the extension into VSCode by clicking the
extensions icon, then the ... and chose the .vsix

.vsix is just a zip file, so you can unzip it to view the files.

Development
-----------

open the vscode-markdown-editor folder in vscode.

If you have not installed the node dependancies, then:

```
(cd vscode-markdown-editor; yarn)
(cd vscode-markdown-editor/media-src; yarn)
```

This extension is multi-layered and has a lot going on. 

run `Terminal > Run Build Task` to make sure there aren't any errors.

Then `Run > Start Debugging` to run the extension and launch a new VScode

You can do cmd+shift+p "Developer: Open Webview Developer Tools" to
bring up the Chrome debugger to debug the webview and see the console
messages for main.ts. Extension.ts can be debugged in the master
vscode.

The vscode extension is
`vscode-markdown-editor/src/extension.ts`. This is built to
`extension.js` and is the main entry point that vscode will run. It is
a modified version of the cat coding example on the "my first vscode
extension" page from Microsoft.

The extension opens the editor as a webview, which is an electron
based UI within a vscode panel. That code is `media-src/main.ts` and
is built into `media/dist`. The webview and extension communicate via
messages set with vscode.message. A large portion of `main.ts` and
`extension.js` is to handle events and pass messages to make things
happen.

`main.ts` runs `vditor` which is a generic browser based markdown
editor; it is quite fancy. It has three editing modes, including the
IR mode which is like Typora or Obsidian. This is the only mode
currently supported by this hacked up extension.

`vditor` uses `lute` under the hood for markdown processing. `lute` is
an impressive go library / program that can parse markdown, form an
ast, and then dispatch to custom renderers. gopherjs is used to
compile this into lute.min.js which `viditor` will load via a CDN url
by default. When viditor is launched, you can specify an alternate
load path for lute with the `_lutePath` option (thanks 64bits!) This
extension bundles a local build of lute.min.js into `media/dist` and
sets `_lutePath` through convoluted means so that the local version of
lute is used by the extension.

## vditor

`patchlutestart.sh` is a tiny script that can be used to copy a new
version of lute into a clone of the vditor repo. Then does a build and
starts the local development copy of vditor on port 9000. This is very
useful for working on lute/vditor interactions.

Currently, no modifications to vditor have been necessary

## lute

This branch of lute has been mercilessly hacked to "support" wikilinks
(e.g. [[wikilink]]). This is involved modifing parse/inline.go and
adding a wikilink ast node. Then the vditor renderers (ir only) have
been modified to support them. 

## overall operation

Regular links show up as `<a>` tags while wikilinks are rendered with
`<span>`. This is how the extension webview distiguishes between a
regular link and a wikilink. A flag is set accordingly in the
`open-link` message sent to the extension. When the extension recieve
an open-link with a span, then it adds a `.md` to the wikilink name
and searches the workspace for the a file with that name and opens the
first result. And this seems to work preety well. 

