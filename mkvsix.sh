#!/bin/sh -x

(cd lute/javascript; ./build.sh)
(cd vscode-markdown-editor; yarn)
(cd vscode-markdown-editor/media-src; yarn)
(cd vscode-markdown-editor; vsce package -o ../releases)
