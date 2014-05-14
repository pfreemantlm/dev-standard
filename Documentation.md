Documentation
=============

Each project will have a `README.md` file that contains:

* Pre-Flight
* Development
* Release

All programs will be delivered with documentation that describes:

* How a programmer of ordinary skill will set up a computer to run and develop the application on their machine
* How a changed git tree can be transmitted to the live embodiment *including any testing or incremental rollout required*

Enumerating dependencies (hardware and software) is required to satisfy the first requirement. How a developer would install these dependencies
would be included in the "Pre-Flight" section.

Some applications need to be run, sometimes with "test data". The developer will need to know how to view the application locally, make a change,
and then review the application with that change. This information must be included in the "Development" section.

Some applications may be tested by installing to a "test server". The documentation of how to do this must be included
to satisfy the second requirement. This literature should placed in the "Release" section.

Some applications must require "testing of features". The documentation of how to do this must be included to satisfy
the second requirement. This may mirror a users-guide, but would be used by Telemetry internal test engineers and the 
infrastructure team. This literature should placed in the "Release" section.

Some contracts may further require an architecture document produced, while others will have an architecture document provided. This file (if necessary)
will be in `Architecture.md`

