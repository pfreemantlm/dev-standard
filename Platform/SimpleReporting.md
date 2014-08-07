Telemetry SimpleReporting
=========================

SimpleReporting is the name of a HTTP GET-based interface for extracting reporting
data from the Telemetry Platform. Output can be produced in CSV, XLS and XLSX formats
for most data sources.

##Composing the Export URL

A SimpleReporting URL starts with the *endpointurl*`/Export/(report)MerlinOverview/` e.g. `https://test5823901.telemetry.com/Export/(report)MerlinOverview/` and will be followed by multiple URL-elements of the form: `(`*parameter*`)`*value* e.g.`(cols)metrics` or `(format)csv` and when finished will look something like this:

    https://test5823901.telemetry.com/Export/(report)MerlinOverview/(startdate)2014-08-01/(enddate)2014-08-31/(metrics)Impacts/(cols)metrics/(format)csv

###(report)MerlinOverview

This is a required parameter with a required value.

###(startdate)

This is an ISO8601 date (i.e. `YYYY-MM-DD`) for the start of reporting data to download.

###(enddate)

This is an ISO8601 date (i.e. `YYYY-MM-DD`) for the *end* of reporting data to download.

The start and end dates are *inclusive*.

###(metrics)

This is a comma-separated list of [metric atoms](#metrics-1).

###(fields)

This is a comma-separated list of [field atoms](#fields-1).

If this is not supplied, only total values will be returned.

###(cols) and (rows)

SimpleReporting can output pivot tables. These parameters contain the [field atoms](#fields-1) in the order they should be present, and the special atom `metrics` where the metrics should be projected.

*For example*, if producing a CSV or XLS output (or don't want a pivot table), and you have the fields `Creative,Placement,Daynum` then you should use:

    (cols)metrics
    (rows)Creative,Placement,Daynum

If you are producing XLSX and want a pivot table, you can do something like this:

    (cols)Placement,Creative,metrics
    (rows)Daynum

###(format)

This should be one of the following strings:

* `csv` for a plain CSV-formatfile
* `xlx` for Microsoft Excel 97/2003-compatible format
* `xlsx` for a modern Microsoft Excel 2007-compatible format


###(advertiser), (award), (region), (tranche), (brand), (campaign), (vendor), (creativeedition)

These are filters.

They contain a comma-separated list of Telemetry GUIDs. To map GUIDs to labels,
you will require a [dictionary](#data-dictionary).

###(technology)

This is a tracking technology:

* `1` for VAST/VPAID/fully-integrated
* `2` for VAST Linear
* `3` for Display
* `4` for Pixel (unverified)
* `5` for MRAID and Mobile VPAID
* `10` for Custom/Bespoke (Externally Served)

Technology breakdown is important since some technologies are unverifiable
and contain whatever the vendor sends to Telemetry (e.g. "4000% clickthrough rates" aren't
uncommon on pixel delivery if the vendor doesn't implement the ad start pixel or they make some kind of trafficking mistake).

##Data Dictionary

You can obtain a data dictionary by making an authenticated request to: *endpointurl*`/Menu/Dictionary/(report)MerlinOverview/(advertiser)`*advertiserguid* and consuming the JSON output.

The `/Menu/Dictionary/` interface actually supports all of the same Telemetry Platform parameters that are available in exporting which can be used to
drastically reduce the size of the dictionary *if so desired*.

From the root keys:

###Fields

This will contain a list of all *fields* (dimensions) that can be used to breakdown of data.

    {
        "Fields": {
            "Ad Format": {
                advanced: true,
                description: "This indicates the type of the ad. This could be In-banner or In-player video.",
                urlpart: "(fields)Format"
                ...
            }
        }
    }

Again, note that the field atom is to be extracted from the `urlpart` key.  

The key `advanced` intimates that the interpretation of this field should be considered carefully. The Telemetry user-interface
decorates these fields differently so that the user is more likely to come across literature about the field.

###Metrics

This will contain a list of all *metrics* that can be extracted.

    {
        "Metrics": {
            "0-25% Completion (%)": {
                advanced: true,
                description: "The percentage of ad views where the ad playback was stopped in the 1st quartile."
                forced_fields: [ "TrackingTechnology" ],
                percent_function: "Completion 0-25%",
                vargroup: "Completion",
                urlpart: "(Metrics)Quartiles0Percent"
                ...
            }
        }
    }

Again, note that the metric atom is to be extracted from the `urlpart` key.  

The key `advanced` has the same meaning for [fields](#fields-1).

The `forced_fields` key is optional: It may contain a list of fields that must be supplied in order to extract this metric *if*
the values of these fields vary. For the example above, if there is more than one TrackingTechnology, then SimpleReporting will not
roll-up the values.

The `percent_function` can be used as a hint for locating simple rate-calculators and identifies the *key* of the function this is
a rate-of (or `false` if this is not a simple rate).

The `vargroup` is a label that may be used as another dimention for grouping metrics.

###Award, Advertiser, Brand, Campaign, Region, Tranche, Vendor

These contain maps whose values are themselves maps, and can be used to look up Telemetry GUIDs.

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

