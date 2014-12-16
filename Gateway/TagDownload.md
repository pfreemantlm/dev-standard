Telemetry TagDownload
=========================
TagDownload is the name of a HTTP GET-based interface of retrieving tags from the Telemetry Platform. 

Tags are downloaded in a bundle by-campaign

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

You can use any Telemetry Placement GUID here, or you can use the special string "all" (without the quotes).

Placement GUIDs can be obtained using [Telemetry SimpleReporting](./SimpleReport.md).


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

