Telemetry CampaignService
=========================

CampaignService uses HTTP POST against *endpointurl*`/User/(campaignservice)`*functionname* for example if your test service is:

    url=https://test5823901.telemetry.com/
    username=x
    password=x

and you wish to perform the [getAdvertisers](#getAdvertisers) function, you perform an HTTP post against:

     https://test5823901.telemetry.com/User/(campaignservice)getAdvertisers

## getAdvertisers


Returns a mapping of ID:Name for all Advertisers available to your Campaign Self Service account. An Advertiser ID will be required to create and update Campaign data.

No input data is required for this function, besides the authentication cookie.

Example Output:

    {
      "success":true,
      "advertisers":
      {
        "800001":"Advertiser One",
        "800002":"Advertiser Two"
      }
    }

## manageCampaign
Creates a new Campaign, or updates an existing Campaign, using the supplied JSON data. Each Campaign is linked to an Advertiser and a Brand, and is a container for Placements used to deliver ads for that Brand. If an ID is supplied for an existing Campaign, that Campaign will be updated (see getCampaigns below to retrieve existing IDs from the system).

The input for a new Campaign requires an Advertiser ID (see getAdvertisers above), and a set of data representing the Campaign: this should contain a year, a brand name, and SQL-formatted start and end dates. Example:

    {
      "advertiserID": 800001,
      "data": 
      { 
        "title": "New Campaign", 
        "year": 2014, 
        "brand":"Brand One", 
        "start":"2014-05-01",
        "end":"2014-07-01"
      }  
    }

For an existing campaign, you must provide the Campaign ID, and the details you wish to update (names and dates only; year and brand cannot be changed after creation). Example:

    {
      "advertiserID": 800001,
      "data": 
      { 
    	"campaignID": 642001,
        "title": "Renamed Campaign", 
        "start":"2014-05-01",
        "end":"2014-07-01"
      }  
    }

Successful Output:

     { "result": 1, "message": "Success", "data": [] }

## getCampaigns

Returns a mapping of ID:Name for Campaigns belonging to the provided Advertiser and year. A Campaign ID will be required for subsequent operations to manage Placements, Creatives, and Tags within that Campaign.

Example Input:

    {
      "advertiserID": 800001, 
      "year":2014
    }

Example Output:

    {
      "success":true,
      "campaigns":
      {
        "642001":"Renamed Campaign [2014]",
        "642002":"Campaign Two [2014]"
      }
    }

## uploadPlan

Imports a spreadsheet of data into the given campaign, creating Placements and outlining their delivery and spend plans. There are also a number of optional attributes which can be provided to enhance Placement reporting and planning.

Input data only requires a Campaign ID, but a CSV or XLS/XLSX media plan is also required. Example JSON input:

    {
      "campaignID": 642001
    }

The input spreadsheet should be separated into a line per Placement “flight”. That is to say, a Placement’s information should be repeated for every set of delivery dates in the plan. See the [sample plan file](./samples/placement_and_plan.xlsx) file for an example.

The spreadsheet *must* contain these column headers:

* **Placement Name** - should be unique to the Vendor and Campaign
* **Site Name** - Vendor’s name
* **Start Date**
* **End Date** - signifies range for the given “flight” - dates should be SQL formatted, eg 2014-01-27
* **Units** - planned number of deliveries for the given date range
* **Type** - the type of Placement; can be one of: 
 * Online Video
 * Display
 * Mobile
 * Companion
* **Cost Structure** - designates the method of payment for deliveries on the Placement; can be one of: 
 * CPM (cost per 1000 ad deliveries)
 * CPC (cost per ad click)
 * CPE (cost per ad engagement)
 * Fixed
 * Free
* **Rate** - the amount, in USD, of the rate of payment in relation to the provided Cost Structure
* **Tracking Level** - signifies the integration level of tags produced for this Placement; can be one of: 
 * Integrated
 * VPAID
 * Mid Level
 * Pixel
 * Hulu
 * Hulu and Integrated

The spreadsheet *may* have these column headers:

* **Telemetry GUID** - supply an existing placement ID to modify the details and/or plan of this placement
* **External Ref** - the client’s own identifier for the placement, for easier reference in reporting

Successful Output:

    { "result": 1, "message": "Success", "data": [] }

## getCreatives

Returns a mapping of ID:Info for Creatives (Ads) available to the given Campaign; ie those matching the Campaign’s Brand. Creative IDs will be needed when assigning Ads to Placements and managing tracking.

Example Input:

    {
      "campaignID": 642001
    }

The output contains, for each Creative ID, the corresponding name and type. The type can be used for identifying between regular video ads, pixels, and companion ads. Example:

    {
      "success":true,
      "creatives":
      {
        "750001":
        {
          "name":"My Brand 640x480",
          "type":"Video"
        },
        "750002":
        {
          "name":"My Brand 300x60 Companion",
          "type”:”Display/Companion"
        }
      }
    }

## getAssignments

Used to determine which Ads are running on which Placements. Returns a set of JSON data representing the current assignment of Editions (aka Creatives) and Companion Creatives to Placements within the given Campaign ID. Should be used to determine existing Placement IDs, needed to update these Assignments and Tracking, and also create Tags.

The input simply takes a Campaign ID:

    {
      "campaignID": 642001
    }

The JSON returned describes the Creatives assigned to each Placement, and each “series” of Companion Creatives on each assignment. In both cases, the “weighting” of the Creative or Companion is also shown. The below example output shows 2 placements; one with 2 editions (50/50 weighted) and another with edition, complete with 1 companion:

    {
      "success":true,
      "assignment":
      [
        {
          "placementID":3300081,
          "placementName":"Test Placement 1",
          "editions":
          [
            {
              "editionID":750001,
              "editionName":"My Brand 640x480",
              "weight":50,
              "policy":"",
              "companionSeries":[]
            },
            {
              "editionID":750073,
              "editionName":"My Different Ad 640x480",
              "weight":50,
              "policy":"",
              "companionSeries":[]
            }
          ]
        },
        {
          "placementID":3300082,
          "placementName":"Test Placement 2",
          "editions":
          [
            {
              "editionID":750001,
              "editionName":"My Brand 640x480",
              "weight":100,
              "policy":"",
              "companionSeries":
              [
                {
                  "seriesID":1,
                  "weight":100,
                  "companions":
                  [
                    {
                      "companionID":750002,
                      "companionName":"My Brand 300x60 Companion",
                      "policy":""
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    }

## uploadAssignments

Imports a spreadsheet of data describing the ads (Editions, aka Creatives) to run on a Placement, along with Companion Ads. The Placement IDs can be retrieved using getAssignments, and the Creative IDs should correspond to those pulled using the getCreatives operation.

Input data only requires a Campaign ID, but a CSV or XLS/XLSX media plan is also required. Example JSON input:

    {
      "campaignID": 642001
    }

The input spreadsheet should be separated into a line per Placement-Edition, with the weight specified. For assigning companions. further lines are then created with the same Placement-Edition information, and a weighting and series ID for each Placement-Edition-Companion line. The “Series ID” is used to group multiple companions together; i.e. these will be served together alongside the same Placement-Edition. Please see [a sample assignment file](./samples/creative_assignment.xlsx).

The spreadsheet *must* contain these column headers:

* **Placement ID** - Telemetry Guid for the Placement, use getAssignments operation to figure out the correct IDs
* **Creative ID** - Telemetry Guid for the Creative, use getCreatives operation to figure out the correct IDs
* **Weight** - The weighting for the Ad to be shown in relation to other ads on “rotation” for this Placement. Eg, 2 ads both at 50 weighting will each show half of the time. Note that if a Companion Creative ID is provided (see below) then this weighting describes that of the Companion on this combination.

And if Companions are required:

* **Companion Creative ID** - Telemetry Guid for the Creative, use getCreatives operation to figure out the correct IDs - should match a Creative of type “Display/Companion”
* **Companion Series** - Those Companion Creatives on the same Placement-Edition combination with a matching Companion Series identifier will be shown at the same time. Thus the weighting must match for each Companion in a series. The identifier can be anything you like, so long as it is unique to the combination.

Note that you can include name columns (e.g. Placement Name, Creative Name) for reference, though these are not used during the upload process.

Succesful Output:

    { "result": 1, "message": "Success", "data": [] }

## getTracking

This returns a set of JSON data similar to the getAssignments operation, but with the inclusion of Tracking pixels assigned to Placement-Creative, and Placement-Creative-Companion combinations. Each combination may have multiple Tracking types, detailed in the uploadTracking operation, and each type may have multiple URLs. This is primarily used to check existing tracking contained within a given campaign.

The input simply takes a Campaign ID:

    {
      "campaignID": 642001
    }


The output shows assignments, minus weighting information, alongside tracking data (types and sets of pixel URLs). In the example output, a Placement-Edition has 2 “Ad Start” pixels, and a Placement-Edition-Companion contains both 1 “Ad Start” pixel and 1 “Clickthrough” tracking pixel:

    {
      "success":true,
      "assignment":
      [
        {
          "placementID":3300081,
          "placementName":"Test Placement 1",
          "editions":
          [
            {
              "editionID":750001,
              "editionName":"My Brand 640x480",
              "companions":[],
              "tracking":
              [
                {
                  "trackingType":"Ad Start",
                  "trackingPixels":
                  [
                    "www.telemetry.com\/sample_impression_tracking\/456",
                    "www.telemetry.com\/sample_impression_tracking_version_two\/456",
                  ]
                }
              ]
            },
            {
              "editionID":750073,
              "editionName":"My Different Ad 640x480",
              "companions":[],
              "tracking": []
            }
          ]
        },
        {
          "placementID":3300082,
          "placementName":"Test Placement 2",
          "editions":
          [
            {
              "editionID":750001,
              "editionName":"My Brand 640x480",
              "companions":
              [
                {
                  "companionID":750002,
                  "companionName":"My Brand 300x60 Companion",
                  "tracking":
                  [
                    {
                      "trackingType":"Ad Start",
                      "trackingPixels":
                      [
                        "www.telemetry.com\/sample_impression_tracking\/123"
                      ]
                    },
                    {
                      "trackingType":"Clickthrough",
                      "trackingPixels":
                      [
                        "www.telemetry.com\/click_tracking\/123"
                      ]
                    }
                  ]
                }
              ]
            }
          ],
          tracking: []
        }
      ]
    }



## uploadTracking

Imports a spreadsheet of data describing the assignments of Tracking pixels (used to send event notifications to 3rd parties) to Placements, Editions, and Companions. The Placement IDs can be retrieved using getAssignments, and the Creative IDs should correspond to those pulled using the getCreatives operation.

Input data only requires a Campaign ID, but a CSV or XLS/XLSX media plan is also required. Example JSON input:

    {
      "campaignID": 642001
    }

Each line in the spreadsheet is used per Tracking Pixel URL we want to assign. Details of the combination to assign to; that is Placement-Edition, or Placement-Edition-Companion; are given alongside the Tracking Event (details below) and Tracking Pixel URL. For multiple URLs, repeat the Event and Assignment for each URL. Please see a [sample trackign sheet](./samples/tracking.xlsx).

The spreadsheet *must* contain these column headers:

* **Placement ID** - Telemetry Guid for the Placement, use getAssignments operation to figure out the correct IDs
* **Creative ID** - Telemetry Guid for the Creative, use getCreatives operation to figure out the correct IDs
* **Tracking Type** - the event we want to fire a pixel for; can be one:
 * **Ad Request** (when the ad is requested by the player/hosting site)
 * **Ad Start** (when the ad begins playback)
 * **Click Event** (tracks when the user clicks on the ad)
 * **Clickthrough Landing** (where the user should end up, ie be redirected to, having clicked on the ad)
 * **Ad Completion**
 * **Mouse Over** (the user’s mouse pointer moves over the ad)
 * **Interaction** (the user engages with a specific interactive element)
 * **Interaction Success** (the user succesfully completes an interactive element)
 * **Interaction Mouseover** (the user’s mouse pointer moves over an interactive element)
 * **Interaction Explored** (useful in interactive elements)
 * **Sustained Mouseover** (mouse is held for a particular period of time)
* **Tracking Pixel** - The 3rd party URL to be fired/redirected to (in the case of Clickthrough Landing event).

Some plugins will expose *additional* tracking types. These are always presented in `ALL_UPPERCASE`.

If Companions are being assigned to, there will be an additional column:

* **Companion Creative ID** - Telemetry Guid for the Creative, use getCreatives operation to figure out the correct IDs - should match a Creative of type “Display/Companion”

Note that you can include name columns (e.g. Placement Name, Creative Name) for reference, though these are not used during the upload process.

Successful Output:

    { "result": 1, "message": "Success", "data": [] }

## createTags

Will produce or update tags, to be served by the appropriate Vendor, for the given Campaign ID and Placement IDs. Tag production will take the required Placement, Creative, and Tracking information from previous steps, and publish tags on the corresponding Vendor’s own Tag Self Service page within TGX.

The input JSON requires the parent Campaign ID, and a set of IDs relating to the Placements we wish to create tags for. Example:

    {
      "campaignID": 642001, 
      "placements":
      [
        3300081, 
        3300082
      ]
    }

Successful Output:

    { "result": 1, "message": "Success", "data": [] }










