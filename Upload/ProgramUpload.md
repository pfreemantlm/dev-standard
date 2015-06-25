Telemetry Program Upload
========================

Your program does a HTTPS POST to https://tartmaster.telemetry.com/deployplayer.php which is protected by IPSEC.

* `file` A ZIP file of the assets to deploy
* `id` The GUID of the upload (normally a git commit ID; try: `git log --pretty=format:'%h' -n 1`)
* `src` The source name (e.g. sauron, as3, roy)

The ZIP file must not have a "base" directory, e.g. create with:

    zip -j file.zip path/to/whatever.js path/to/whatever.swf ...

The HTTP response code will be one of the following:

* `200` - the body is the path segment `/tv2n/p/`*src*`/`*id*`/`
* `504` - the file is being transferred to the CDN; sleep 1 second and try again

All other errors are permanent failures. Review the response text for guidance.

Once your program receives a successful (200) result, you can use:

    curl -L http://cdn.telemetryverification.net/tv2n/p/src/id/whatever.js

to get the url.


