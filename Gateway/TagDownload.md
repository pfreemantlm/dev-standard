Telemetry TagDownload
=========================
TagDownload is the name of a HTTP GET-based interface of retrieving tags from the Telemetry Platform. 

Tags are downloaded in ZIP files in a bundle by-group. Inside the ZIP file is a number of folders and "tag files"
which delivery should be sent to. The folder names match the "Telemetry Tag Name" which can be obtained from [Telemetry SimpleReporting](./SimpleReporting.md).

* `In-Player GUID.txt` - Used by bespoke integrations
* `Creative Pixels.txt` - list of pixels to fire for site-served traffic
* `Creative Paths.txt` - list of urls that HQ site-served creatives can be downloaded from
* `Companion Ad HTML.txt` - HTML "iframe"-based companion tag, used when companions are trafficked separately
* `Companion Ad JavaScript.txt` - HTML "script tag"-based companion tag, used when companions are trafficked separately
* `Companion Creative Paths.txt` - list of urls that the raw companions can be downloaded from
* `Companion Pixel Click URL.txt` - list of clickthrough pixels for the companion
* `Companion Pixel Impact URL.txt` - list of "impression" pixels for the companion
* `MRAID Javascript Tag.txt` - HTML-based "script tags" to load an MRAID interstitial
* `MRAID URL Tag.txt` - The URL of the MRAID interstitial
* `VAST 2 Linear URL.txt` - a url that returns IAB Standard VAST; the `<MediaFile>` will be a linear video (MP4/WEBM/etc)
* `VAST 2 Linear Wrapper.txt` - an IAB XML-formatted VAST Wrapper for the above
* `In-Player VAST 2 -ActionScript 3-0- VPAID URL.txt` - a url that eturns IAB Standard VAST; the `<MediaFile>` will be VPAID for Desktop
* `In-Player VAST 2 -ActionScript 3-0- VPAID Wrapper.txt` - an IAB XML-formatted VAST Wrapper for the above.
* `HTML5 VPAID Javascript Tag URL.txt` - a url that eturns IAB Standard VAST; the `<MediaFile>` will be VPAID2.0 JavaScript
* `HTML5 VPAID Javascript Tag Wrapper.txt` - an IAB XML-formatted VAST Wrapper for the above.

##Composing the Export URL

A TagDownload URL starts with the *endpointurl*`/Export/(report)Tags/` e.g. `https://test5823901.telemetry.com/Export/(report)Tags/` and will be followed by multiple URL-elements of the form: `(`*parameter*`)`*value* e.g.`(package)all` or `(format)zip` and when finished will look something like this:

    https://test5823901.telemetry.com/Export/(report)Tags/(entry)ReportMiscEntryTagviewer/(tranche)1311043/(package)all/(format)zip

###(report)Tags

This is a required parameter with a required value.

###(entry)ReportMiscEntryTagviewer

This is a required parameter with a required value.

###(format)zip

This is a required parameter with a required value.

###(tranche)

This is a required filter. 

You can use tranche values obtained from the [Data Dictionary](#Data Dictionary).

###(package)

This is a required filter. 

You can use any Telemetry Package GUID here, or you can use the special string "all" (without the quotes).

Package GUIDs can be obtained using [Telemetry SimpleReporting](./SimpleReport.md).


##Data Dictionary

Note this is the same format as the [Telemetry SimpleReporting](./SimpleReporting.md), but only the Tranche (group) field is used.

You can obtain a data dictionary by making an authenticated request to: *endpointurl*`/Menu/Dictionary/(report)MerlinOverview/(advertiser)`*advertiserguid* and consuming the JSON output.

The `/Menu/Dictionary/` interface actually supports all of the same Telemetry Platform parameters that are available in exporting which can be used to
drastically reduce the size of the dictionary *if so desired*.

From the root, there is a "Tranche" key.

It contain maps whose values are themselves maps, and can be used to look up Telemetry GUIDs.

    {
        "Tranche": {
            "Test Group-USA [2014] Video": {
                id: "69",
                label: "Test Group-USA [2014] Video",
                urlpart: "(tranche)69"
                ...
            }
        }
    }

To select multiple GUIDS on the same parameter, simply join them with commas, e.g. `(tranche)69` and `(tranche)42` can become `(tranche)42,69`

