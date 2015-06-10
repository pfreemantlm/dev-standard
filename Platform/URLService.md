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

Using the parameter `(urlservice)blame` this will update a list.

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

