Telemetry CampaignService
=========================

CampaignService uses HTTP POST against *endpointurl*`/User/(campaignservice)`*functionname* for example if your test service is:

    url=https://test5823901.telemetry.com/
    username=x
    password=x

and you wish to perform the [getAdvertisers](#getAdvertisers) function, you perform an HTTP post against:

     https://test5823901.telemetry.com/User/(campaignservice)getAdvertisers

## getAdvertisers

Using the parameter `(campaignservice)getAdvertisers` this will return a mapping of ID:Name for all Advertisers available to your Campaign Self Service account. An Advertiser ID will be required to create and update Campaign data.

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


## getRegions

Using the parameter `(campaignservice)getRegions` this will return a mapping of ID:Name for all Regions available to the provided Advertiser.

The HTTP POST argument (application/x-www-form-urlencoded) "advertiserID" should be set to the advertiser ID.

Example Input:

    advertiserID=800001

Example Output:

    {
      "success":true,
      "regions":
      {
        "920001":"USA",
        "920002":"Canada"
      }
    }

## getBrands


Using the parameter `(campaignservice)getBrands` this will return a mapping of ID:Name for all Brands available to the provided Advertiser. A Brand name will be required to create and update Campaign data.

The HTTP POST argument (application/x-www-form-urlencoded) "advertiserID" should be set to the advertiser ID.

Example Input:

    advertiserID=800001

Example Output:

    {
      "success":true,
      "brands":
      {
        "970001":"Brand One",
        "970002":"Brand Two"
      }
    }


## manageCampaign

Using the parameter `(campaignservice)manageCampaign` will create a new Campaign, or update an existing Campaign, using the supplied JSON data. Each Campaign is linked to an Advertiser and a Brand, and is a container for Placements used to deliver ads for that Brand. If an ID is supplied for an existing Campaign, that Campaign will be updated (see getCampaigns below to retrieve existing IDs from the system).

The input for a new Campaign requires an Advertiser ID (see getAdvertisers above), and a set of data representing the Campaign: this should contain a year, a brand name, and SQL-formatted start and end dates. Example:

The HTTP POST argument (application/x-www-form-urlencoded):

* `advertiserID` should be set to the advertiser ID,
* `data[title]` should be the (display) name of the campaign,
* `data[year]` should be the campaign year (usually the same as the start date)
* `data[brand]` should be the string name of the Brand (but matching something returned from getBrands above)
* `data[start]` should be the ISO-formatted start date
* `data[end]` should be the ISO-formatted end date

Example Input:

    advertiserID=800001&data[title]=New%20Campaign&data[year]=2014&data[brand]=Brand%20One&data[start]=2014-05-01&data[end]=2014-07-01

For an existing campaign, you must provide the Campaign ID as `data[campaignID]`:

    advertiserID=800001&data[title]=New%20Campaign&data[year]=2014&data[brand]=Brand%20One&data[start]=2014-05-01&data[end]=2014-07-01&data[campaignID]=642001

Successful Output:

     { "result": 1, "message": "Success", "data": [] }

## getCampaigns

Using the parameter `(campaignservice)getCampaigns` will return a mapping of ID:Name for Campaigns belonging to the provided Advertiser and year. A Campaign ID will be required for subsequent operations to manage Placements, Creatives, and Tags within that Campaign.

The HTTP POST argument (application/x-www-form-urlencoded) "advertiserID" should be set to the advertiser ID,
and the target campaign year as "year" should be supplied.

Example Input:

    advertiserID=800001&year=2014

Example Output:

    {
      "success":true,
      "campaigns":
      {
        "642001":"Renamed Campaign [2014]",
        "642002":"Campaign Two [2014]"
      }
    }
    
    
## getVendors


Returns a mapping of ID:Name for all on-boarded Vendors available to the provided Advertiser. Vendor names will be required to upload Plan information into a Campaign; the Vendor must be associated with the Advertiser already through the on-boarding process that precedes each Vendor’s involvement in a Campaign.

Note that occasionally a vendor may be referred to with multiple names so note the "alternateVendorNames" section if it is present.

The HTTP POST argument (application/x-www-form-urlencoded) "advertiserID" should be set to the advertiser ID.

    advertiserID=800001

Example Output:

    {
      "success":true,
      "vendors":
      {
        "840001":"Test Vendor 1",
        "840002":"Test Vendor 2"
      },
      "alternateVendorNames":
      {
        "Test Vendor 1 Old Name":"840001"
      }
    }


## uploadPlans

Using the parameter `(campaignservice)uploadPlans` will import a spreadsheet of data into the given campaign, creating Placements and outlining their delivery and spend plans. There are also a number of optional attributes which can be provided to enhance Placement reporting and planning.

The HTTP POST argument contains a (multipart/form-data) file (CSV, XLS or XLSX) file called "file"
and an already-existing "campaignID" of the appropriate format.

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
 * Package - will not contain tag items unless items are moved under it, using the packageItems function.
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



## packageItems

Using the parameter `(campaignservice)packageItems` will assign a set of placements underneath a "package" placement's plan. For each package assignment, you provide the ID for the parent; that is the item with the plan you wish to use, and a set of child IDs; that is those items you wish to move underneath this plan. 

All placements must belong to the given campaignID, and the same vendor in order to be packaged together.

The HTTP POST argument (application/x-www-form-urlencoded):

* `campaignID` should be the campaign containing all the given placements,
* `packages[0][parentID]` should be the ID of the item we wish to set as the first parent package,
* `packages[0][children][]` should be the ID of an item we wish to move into this first package,
* `packages[0][children][]` should be the ID of another item we wish to move into this first package,
* `packages[1][parentID]` should be the ID of the item we wish to set as the second parent package,
* `packages[1][children][]` should be the ID of an item we wish to move into this second package,

Example Input:

    campaignID=642001&packages[0][parentID]=3300080&packages[0][children][]=3300082&packages[0][children][]=3300081


Successful Output:

    { "result": 1, "message": "Success", "data": [] }


## getCreatives

Using the parameter `(campaignservice)getCreatives` will returns a mapping of ID:Info for Creatives (Ads) available to the given Campaign; ie those matching the Campaign’s Brand. Creative IDs will be needed when assigning Ads to Placements and managing tracking.

The HTTP POST argument (application/x-www-form-urlencoded) "campaignID" is a campaign ID that has
already been created.

Sample input:

    campaignID=642001


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

## getCreativesEditions

Using the parameter `(campaignservice)getCreativesEditions` will returns a mapping of ID:Info for Creative Groups available to the given Brand.

The HTTP POST argument (application/x-www-form-urlencoded) "brandID" is a brand ID that has already been created.

Sample input:

    brandID=970001

The output contains, for each Creative Group ID, the corresponding name and the creatives in that group. For each Creative ID, the output contains the corresponding name, path and type. The path is the URI path on the CDN for the ad's primary flash video or banner file. The type can be used for identifying between regular video ads, pixels, and companion ads. If the creative group has been created with no creatives attached, the creatives data will be empty. Example:

    {
      "success":true,
      "creativegroups":
      {
        "710001":
        {
          "name":"My Brand 640x480",
          "creatives":{
          	"750001": {
          	  "name":"My Brand 640x480",
          	  "path":"/content/mybrand/mybrand_640x480.swf",
          	  "type":"Video"
          	}
          }
        },
        "710003":
        {
          "name":"My Brand 300x250 Companion",
          "creatives”:[]
        }
      }
    }


## getAssignments

Used to determine which Ads are running on which Placements. Returns a set of JSON data representing the current assignment of Editions (aka Creatives) and Companion Creatives to Placements within the given Campaign ID. Should be used to determine existing Placement IDs, needed to update these Assignments and Tracking, and also create Tags.

The HTTP POST argument (application/x-www-form-urlencoded) "campaignID" should be set to the campaign ID.

Sample input:

    campaignID=642001

The JSON returned describes the Creatives assigned to each Placement, and each “series” of Companion Creatives on each assignment. In both cases, the “weighting” of the Creative or Companion is also shown. If the Placement has a schedule for Creatives & Companions, then the Creatives appear in a different object, with a start and end date for each scheduled block. The below example output shows 2 placements; one with a schedule comprised of 3 editions; and another with 1 edition, complete with 1 companion:

    {
      "success":true,
      "assignment":
      [
        {
          "placementID":3300081,
          "placementName":"Test Placement 1",
          "edition_schedules":
          [
            {
              "editionID":750001,
              "editionName":"My Brand 640x480",
              "weight":100,
              "policy":"",
              "companionSeries":[],
              "start":"2014-08-01 00:00:00",
              "end":"2014-08-14 23:59:59"
            },
            {
              "editionID":750073,
              "editionName":"My Different Ad 640x480",
              "weight":50,
              "policy":"",
              "companionSeries":[],
              "start":"2014-08-15 00:00:00",
              "end":"2014-08-29 23:59:59"
            },
            {
              "editionID":750179,
              "editionName":"Another Ad 640x480",
              "weight":50,
              "policy":"",
              "companionSeries":[],
              "start":"2014-08-15 00:00:00",
              "end":"2014-08-29 23:59:59"
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

Using the parameter `(campaignservice)uploadAssignments` will imports a spreadsheet of data describing the ads (Editions, aka Creatives) to run on a Placement, along with Companion Ads. The Placement IDs can be retrieved using getAssignments, and the Creative IDs should correspond to those pulled using the getCreatives operation.

The HTTP POST argument contains a (multipart/form-data) file (CSV, XLS or XLSX) file called "file"
and an already-existing "campaignID" of the appropriate format.

The input spreadsheet should be separated into a line per Placement-Edition, with the weight specified. For assigning companions. further lines are then created with the same Placement-Edition information, and a weighting and series ID for each Placement-Edition-Companion line. The “Series ID” is used to group multiple companions together; i.e. these will be served together alongside the same Placement-Edition. Please see [a sample assignment file](./samples/creative_assignment.xlsx).

You can also schedule which Creatives or Companions run at a particular time on a Placement. Repeat each row with UTC Start and End dates for every scheduled period, setting the weight of each active Creative or Companion at the appropriate time. When uploading, the full schedule must be included and will take precedence over any previous schedules on each Placement. Please see [an example of creative scheduling](./samples/creative_assignment_schedules.xlsx).

The spreadsheet *must* contain these column headers:

* **Placement ID** - Telemetry Guid for the Placement, use getAssignments operation to figure out the correct IDs. Note these are numeric so they must not have double-quotes around them.
* **Creative ID** - Telemetry Guid for the Creative, use getCreatives operation to figure out the correct IDs. Note these are numeric so they must not have double-quotes around them.
* **Weight** - The weighting for the Ad to be shown in relation to other ads on “rotation” for this Placement. Eg, 2 ads both at 50 weighting will each show half of the time. Note that if a Companion Creative ID is provided (see below) then this weighting describes that of the Companion on this combination. Note the weights numeric so they must not have double-quotes around them.

If Companions are required:

* **Companion Creative ID** - Telemetry Guid for the Creative, use getCreatives operation to figure out the correct IDs - should match a Creative of type “Display/Companion”.  Note these are numeric so they must not have double-quotes around them.
* **Companion Series** - Those Companion Creatives on the same Placement-Edition combination with a matching Companion Series identifier will be shown at the same time. Thus the weighting must match for each Companion in a series. The identifier can be anything you like, so long as it is unique to the combination.
 
And if scheduling:

* **Start** - SQL formatted date (and optional time) *in UTC* for the start of a scheduled creative, eg "2014-08-01 09:00:00". If only a date is specified, it assumed to be the start of the given day (00:00:00).
* **End** - SQL formatted date (and optional time) *in UTC* for the end of a schedule creative. If only a date is specified, it is assumed to be the end of the given day (23:59:59). Within a placement's schedule, there must be no gaps and overlaps of time periods.

Note that you can include name columns (e.g. Placement Name, Creative Name) for reference, though these are not used during the upload process.

Note that when scheduling, the Creatives & Companions on the earliest time period will run from the moment of a successful `createTags` call until the given end date. Similarly, the Creatives on the latest time period will run indefinitely, until new schedules are uploaded, if a tag served beyond the given end date. If only one time block is specified, it will have the same effect as no schedule at all; these Creatives & Companions will run from now, indefinitely.

Succesful Output:

    { "result": 1, "message": "Success", "data": [] }

## getTracking

Using the parameter `(campaignservice)getTracking` will return a set of JSON data similar to the getAssignments operation, but with the inclusion of Tracking pixels assigned to Placement-Creative, and Placement-Creative-Companion combinations. Each combination may have multiple Tracking types, detailed in the uploadTracking operation, and each type may have multiple URLs. This is primarily used to check existing tracking contained within a given campaign.

The HTTP POST argument (application/x-www-form-urlencoded) "campaignID" is a campaign ID that has
already been created.

Sample input:

    campaignID=642001

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

Using the parameter `(campaignservice)uploadTracking` will import a spreadsheet of data describing the assignments of Tracking pixels (used to send event notifications to 3rd parties) to Placements, Editions, and Companions. The Placement IDs can be retrieved using getAssignments, and the Creative IDs should correspond to those pulled using the getCreatives operation.

The HTTP POST argument contains a (multipart/form-data) file (CSV, XLS or XLSX) file called "file"
and an already-existing "campaignID" of the appropriate format.

Each line in the spreadsheet is used per Tracking Pixel URL we want to assign. Details of the combination to assign to; that is Placement-Edition, or Placement-Edition-Companion; are given alongside the Tracking Event (details below) and Tracking Pixel URL. For multiple URLs, repeat the Event and Assignment for each URL. Please see a [sample tracking sheet](./samples/tracking.xlsx).

The spreadsheet *must* contain these column headers:

* **Placement ID** - Telemetry Guid for the Placement, use getAssignments operation to figure out the correct IDs. Note these are numeric so they must not have double-quotes around them.
* **Creative ID** - Telemetry Guid for the Creative, use getCreatives operation to figure out the correct IDs. Note these are numeric so they must not have double-quotes around them.
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

* **Companion Creative ID** - Telemetry Guid for the Creative, use getCreatives operation to figure out the correct IDs - should match a Creative of type “Display/Companion”. Note these are numeric so they must not have double-quotes around them.

Note that you can include name columns (e.g. Placement Name, Creative Name) for reference, though these are not used during the upload process.

Successful Output:

    { "result": 1, "message": "Success", "data": [] }

## createTags

Using the parameter `(campaignservice)createTags` will produce or update tags, to be served by the appropriate Vendor, for the given Campaign ID and Placement IDs. Tag production will take the required Placement, Creative, and Tracking information from previous steps, and publish tags on the corresponding Vendor’s own Tag Self Service page within TGX.

The HTTP POST argument (application/x-www-form-urlencoded) "campaignID" should be set to the existing
campaign ID, and the placements should be supplied as multiple "placements[]" arguments. Each item in the "placements[]" arguments refers to a single placement; supplying a package ID (for a parent used in packageItems) will not automatically create tags for everything underneath it.

Sample input:

    campaignID=642001&placements[]=3300081&placements[]=3300082

Successful Output:

    { "result": 1, "message": "Success", "data": [] }










