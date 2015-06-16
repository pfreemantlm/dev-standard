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

## brandUnsafeUpdate

Using the parameter `(urlservice)brandunsafeupdate` will update the brand safe categorisation applied to a particular advertiser. Specifying a list of categories deemed to be unsafe, and a list of domains to be excluded from consideration. For each category to add as unsafe, you specify the category name, as used in the zvelo database, and the date from which the category should be considered unsafe.

The HTTP POST argument (application/x-www-form-urlencoded):

* advertiserID - the Advertiser ID e.g. 900001
* unsafecategory[0][categoryname] should be the name of the first category we with to include in the list
* unsafecategory[0][startdate] should be the date, in yyyy-mm-dd format, from which point the first category should be applied
* unsafecategory[0][enddate] should be the date, in yyyy-mm-dd format, from which the first category should stop being applied (optional)
* unsafecategory[1][categoryname] should be the name of the second category we with to include in the list
* unsafecategory[1][startdate] should be the date in, yyyy-mm-dd format, from which point the second category should be applied
* unsafecategory[1][enddate] should be the date in, yyyy-mm-dd format, from which the second category should stop being applied (optional)
* whitelistdomain[0][domain] should be the name of the first domain to exclude from unsafe category
* whitelistdomain[0][startdate] should be the date in, yyyy-mm-dd format, from which first domain should be applied
* whitelistdomain[0][enddate] should be the date in, yyyy-mm-dd format, from which first domain should be applied (optional)
* whitelistdomain[1][domain] should be the name of the second domain to exclude from unsafe category
* whitelistdomain[1][startdate] should be the date in, yyyy-mm-dd format, from which second domain should be applied
* whitelistdomain[1][enddate] should be the date in, yyyy-mm-dd format, from which second domain should be applied (optional)


There is a limit of 256 categories and 256 domains that can be applied to an advertiser

Example Input:

    advertiserID=900001&unsafecategory[0][categoryname]=Gambling&unsafecategory[0][startdate]=2015-01-01&unsafecategory[1][categoryname]=Criminal%20Skills%2FHacking&unsafecategory[1][startdate]=2015-01-01&unsafecategory[0][enddate]=2015-08-01&whitelistdomain[0][domain]=yahoo.com&whitelistdomain[0][startdate]=2015-02-28


Successful Output:

    { "result": 1, "message": "Success", "data": [] }

