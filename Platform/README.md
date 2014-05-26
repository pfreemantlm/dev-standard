Telemetry Platform
==================

This tree documents the configuration of the reporting platform. You are encouraged to check it out.

An Advertiser forms the root of configuration. They will have a number of brands,
and brands will have a number of campaigns.

A campaign consists of a [media plan](./samples/placement_and_plan.xlsx) that labels placements,
a [creative-assignment](./samples/creative_assignment.xlsx) that maps placements and creatives to editions,
and [tracking data](./samples/tracking.xlsx)  for listing third- and fourth-party tracking configuration to editions.

Once configured, the platform can create tags for a vendor to deliver against those placements.

During implementation, configuration occurs against a "test server" which differs from
the live system in the following ways:

* The Test system is wiped/refreshed weekly (Friday at 7am UTC)
* Requests to the test server will error out roughly 10% of the time (instead of 1% in live)
* Tags can only be pulled from the test system by setting [an HTTP cookie](./Tags.md#Testing)

Your application should take as an argument a file containing credentials. It looks like this:

    url="http://url_of_test_server"
    username="supplied_username"
    password="supplied_password"

Your application should allow shell-style (backslash) escapes in this file.

With it your application will need to:

* [Log in](./LoginService.md) to the test system, saving the cookies the login service generates
* Perform HTTP post to [CampaignService](./CampaignService.md) to configure the test server
* [Verify and test](./Tags.md#Testing) the tags created.

