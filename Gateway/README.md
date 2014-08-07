Telemetry Platform
==================

This tree documents the reporting platform. You are encouraged to check it out.

During implementation, queries can occur against a "test server" which differs from
the live system in the following ways:

* Reporting data will not be live customer reporting data
* Requests to the test server will error out roughly 10% of the time (instead of 1% in live)

Your application should take as an argument a file containing credentials. It looks like this:

    url="http://url_of_test_server"
    username="supplied_username"
    password="supplied_password"

Your application should allow shell-style (backslash) escapes in this file.

With it your application will need to:

* [Log in](../LoginService/README.md) to the test system, saving the cookies the login service generates
* Perform HTTP get [SimpleReporting](./SimpleReporting.md) to query reports
