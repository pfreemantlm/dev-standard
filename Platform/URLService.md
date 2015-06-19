Telemetry URLService
====================

URLService uses HTTP POST against *endpointurl*`/User/(urlservice)`*functionname* for example if your test service is:

    url=https://test5823901.telemetry.com/
    username=x
    password=x

and you wish to perform the [update](#update) function, you perform an HTTP post against:

     https://test5823901.telemetry.com/User/(urlservice)update

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
