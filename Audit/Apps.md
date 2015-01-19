Telemetry Audit API - Apps
==========================

Apps Audiding uses HTTP POST against *endpointurl*`/User/(appaudit)`*functionname* for example if your test service is:

    url=https://test5823901.telemetry.com/
    username=x
    password=x

and you wish to perform the [searchApps](#searchApps) function, you perform an HTTP post against:

    https://test5823901.telemetry.com/User/(appaudit)searchApps


## searchApps

Returns a mapping of ID:Name for Apps matching the given search string. The input consists of a search string, which needs to be 3 or more characters in length.

Example:

    {
      "search": "Tel"
    }

Example Output:

    {
      "success":true,
      "apps":
      {
        "aabbcc123456":"Telemetry iPhone Sample App",
        "aabbcd123499":"Telemetry Android Test"
      }
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
