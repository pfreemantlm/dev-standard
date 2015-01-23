Telemetry Audit API - Apps
==========================

Apps Audiding uses HTTP POST against *endpointurl*`/User/(appaudit)`*functionname* for example if your test service is:

    url=https://test5823901.telemetry.com/
    username=x
    password=x

and you wish to perform the [searchApps](#searchApps) function, you perform an HTTP post against:

    https://test5823901.telemetry.com/User/(appaudit)searchApps


## searchApps

Returns details for Apps matching the given ID search string (**"search"**). The input consists of a search string, which needs to be 3 or more characters in length. 

By default, all App Stores are searched by matching ID, or a Store Identifier (**"storeID"**) can be provided to search within the relevant store. The available store IDs are:

* **1** = iTunes
* **2** = Google Play

Each item in the returned list contains details for an individual app, including Telemetry's own unique ID for further queries in the API. The details are:

* **telemetryID** = our own unique identifier for an app; use this in subsequent API calls.
* **storeKey** = the ID used for this app in the relevant store
* **bundleID** (optional) = additional ID referencing the app's package within the iTunes store only.
* **store** = the App Store where this app can be found (eg, iTunes)
* **os** = the platform for this application (eg, iOS)
* **name** = Title of the app
* **developer** = Name of the developer (person/company)
* **status** = Tells us if we have data for the app, or if it's new. Possible values are: 'NODATA', 'NEW', and 'OK'
* **addedOn** = The date at which we entered the application into our App Database

Example (looks in all stores):

    {
      "search": "605"
    }

Example (in the iTunes/Apple Store only):

    {
      "search": "389",
      "storeID": 1
    }
    
Example Output:

    {
        "success":true,
        "apps":
        [
            {
                "telemetryID": 6,
                "storeKey": 389129317
                "bundle": "info.smartpocket.ebook590",
                "store": 1,
                "os": iOS,
                "name": "Christmas Sunshine",
                "developer": "DSG",
                "status": "OK",
                "addedOn": "2015-01-15 12:30:12"
            },
            {
                "telemetryID": 673,
                "storeKey": 389306390
                "bundle": "HindiSms",
                "store": 1,
                "os": 1,
                "name": "Hindi SMS",
                "developer": "JOSE CHERIAN",
                "status": "OK",
                "addedOn": "2015-01-15 12:30:12"
            }
        ]
    }


## addObservation

TODO: To be documented.

## getEvents

Returns data for observations made against the provided App ID. The input requires a full and valid App ID, and the return value contains a list of data for each observation (with a maximum of the last 50 observerations).

Example

    {
      "appID": "aabbcc123456"
    }


The output values are the same as those input to [addObservation](#addObservation), with the following additions:

* **created_on** - Timestamp for when the observation was recorded.
* **created_by** - User who recorded the observation (username).
* **time_spent** - Length of time in seconds between the start of the App test and the completed observation.

TODO: bundle ID???

Example Output:

    {
      "success":true,
      "observations":
      [
        {
          "created_on":1234678000, 
          "created_by":"gcarncross", 
          "bundleID":"xyzabc789", 
          "time_spent":60, 
          "visible": true, 
          "audible":false, 
          "click_to_start":true, 
          "responsive":true, 
          "skippable":true,
          "never_saw_ad":false
        },
        {
          "created_on":1234999000, 
          "created_by":"asharp", 
          "bundleID":"xyzabc789", 
          "time_spent":67, 
          "visible": true, 
          "audible":true, 
          "click_to_start":false, 
          "responsive":true, 
          "skippable":false,
          "never_saw_ad":false
        }
      ]
    }

## getScores

TODO: To be documented.
