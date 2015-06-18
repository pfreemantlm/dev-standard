Telemetry URLService
====================

URLService uses HTTP POST against *endpointurl*`/User/(urlservice)`*functionname* for example if your test service is:

    url=https://test5823901.telemetry.com/
    username=x
    password=x

and you wish to perform the [update](#update) function, you perform an HTTP post against:

     https://test5823901.telemetry.com/User/(urlservice)update

## configure

Using the parameter `(urlservice)configure` this will get the configuration
for a (potentially new) policy list for an advertiser+region combination.

You will need the advertiserID and regionID which can be obtained from
[CampaignService](./CampaignService.md#getRegions) or from [SimpleReporting](../Gateway/SimpleReporting.md#data-dictionary).

The HTTP POST arguments (application/x-www-form-urlencoded) required are:

* `advertiserID` - the Advertiser ID e.g. 900001
* `regionID` - the advertiser region ID e.g. 800001
* `label` - a label name
* `createp` - present and set to 1 if the policy list should be created.

The label name will be used in [update](#update) and other calls.

Example Output:

    {
        "success": true,
        "policyString": "*IBAAAQ=",
        "listID": 107
    }

The `policyString` is in a format compatible with [the ZVELOBLOCK](PolicyRules.md#zveloblock) parameter. The `listID` may be present if a single list ID is allocated for this advertiser+region+label combination.

## blame

Using the parameter `(urlservice)blame` this will get the time
that a URL was added, and by whom.

The HTTP POST arguments (application/x-www-form-urlencoded) required are:

* `advertiserID` - the Advertiser ID e.g. 900001
* `regionID` - the advertiser region ID e.g. 800001
* `label` - a label name. See [configure](#configure) for details.
* `url[]` - may be supplied multiple times. Lists urls to return information on.

Example Output:

    {
        "success": true,
        "results": [
            {
                "lastUpdated": "2012-01-01T05:05:00",
                "created": "2009-01-01T05:05:00",
                "updatedBy": "gcarncross",
                "createdBy": "gcarncross",
                "url": [ "example.com" ]
            }
        ]
    }

If a domain is in the supplement (see [update](#update)) then it may not have
a "created" or an "createdBy" section.

## update

Using the parameter `(urlservice)update` this will update a list.

The HTTP POST arguments (application/x-www-form-urlencoded) required are:

* `advertiserID` - the Advertiser ID e.g. 900001
* `regionID` - the advertiser region ID e.g. 800001
* `label` - a label name. See [configure](#configure) for details.
* `url[]` - may be supplied multiple times.
* `supplementp` - see below.

A URL list consists of two parts: a "main" section, and a "supplemental"
section. The purpose of the supplemental section is for monitoring the
list management machinery and *not* for customer updates to the list. As a
result, urls in the supplement are not logged. Do not set `supplementp` unless
you are building tools to verify that the list is being updated correctly.

Example Output:

    {
        "success": true
    }

## uploadBrandUnsafeConfig

Using the parameter `(urlservice)uploadBrandUnsafeConfig` will import two spreadsheets of data describing the brand unsafe configuration to apply for a particular advertiser. The first spreadsheet is a list of categories deemed to be unsafe, the second is a list of domains to be excluded from consideration. For each category to add as unsafe, you specify the category name, as used in the zvelo database, and the date from which the category should be considered unsafe.

The HTTP POST argument contains a (multipart/form-data) an already-existing "advertiserID" of the appropriate format, a CSV file called "categoryfile" and a CSV file called "domainfile". Both categortyfile and domainfile are required in all uploads.

The categoryfile file must contain these column headers:

* **Category** - The name of the category deemed to be unsafe.
* **Unsafe From** - the date, in yyyy-mm-dd format, from which point the category should be applied.
* **Unsafe Until** - the date, in yyyy-mm-dd format, from which point the category should cease being applied (optional).

Example:

    "Category","Unsafe From","Unsafe Until"
    "Gambling",2015-01-01,
    "Criminal Skills/Hacking",2015-01-01,2015-08-01

The domainfile file must contain these column headers:

* **Domain** - The name of the domain to exclude from unsafe metrics
* **Exclude From** - the date, in yyyy-mm-dd format, from which point the domain should be excluded
* **Exclude Until** - the date, in yyyy-mm-dd format, from which point the domain should cease being excluded (optional)

Example:

    "Domain","Exclude From","Exclude Until"
    "poker.facebook.com",2015-02-28,

There is a limit of 256 categories and 65535 domains that can be applied to an advertiser

Successful Output:

    { "result": 1, "message": "Success", "data": [] }

## getBrandUnsafeConfig

Using the parameter `(urlservice)getBrandUnsafeConfig` will return a set of JSON data describing the currently active brand unsafe configuration for the specied advertiser.

The HTTP POST argument (application/x-www-form-urlencoded) "advertiserID" is a advertiser ID that has already been created.

Sample input:

	advertiserID=900001

Sample Output:

	{
  		"success": true,
  		"advertiserID": 900001,
  		"lastChangedTime": "2015-06-18 12:03:34",
  		"lastChangedUser": "goffer@dave",
  		"unsafeCategories":
  		[
  			{
  				"categoryName": "Gambling",
  				"unsafeFrom": "2015-01-01"
  			},
  			{
  				"categoryName": "Criminal Skills/Hacking",
  				"unsafeFrom": "2015-01-01",
  				"unsafeUntil": "2015-08-01"
  			}
  		],
  		"excludeDomains":
  		[
  			{
  				"domainName": "poker.facebook.com",
  				"excludeFrom": "2015-02-28"
  			}
  		]
 	}

## getBrandUnsafeLastChanges

Using the parameter `(urlservice)getBrandUnsafeLastChanges` will return a set of JSON data describing the time and user that performed the last brand unsafe configuration update for the specied advertiser.

The HTTP POST argument (application/x-www-form-urlencoded) "advertiserID" is a advertiser ID that has already been created.

Sample input:

	advertiserID=900001

Sample Output:

	{
  		"success": true,
  		"advertiserID": 900001,
  		"lastChangedTime": "2015-06-18 12:03:34",
  		"lastChangedUser": "goffer@dave"
	}
