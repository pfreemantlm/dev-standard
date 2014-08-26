Documentation
=============

All Telemetry literature uses the *active voice* (i.e. you will, you must, etc).

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED",  "MAY", and "OPTIONAL" in
any Telemetry documentation are to be interpreted as described in [RFC 2119](https://www.ietf.org/rfc/rfc2119.txt).

Dcoumentation will not intimate that the reader *can* do something without explaining *how they will know*.

##Requirements for Projects

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

Any external servers required by the application must be enumerated. Failure-planning for each external service must be documented.


##Requirements for Interface

Interface documentation will describe clearly what the user of the interface will be expected to know before the interface is called.

It will also explain how to obtain that knowledge:

* From the user of the application
* From another interface
* From an inductive process reasoning about the inputs

All interfaces describe the *wire protocol* and not an *application protocol*. Any special requirements about headers and encoding must be documented,
even if these requirements are otherwise the defaults of some transport library.

Interfaces must be *idempotent*, which means they can be called multiple times to the same effect, or they must require a transaction header *and remember*
that transaction's status.

##Requirements for Process

Process documentation will describe clearly and linearly the steps needed to complete a task.

If a step is optional, the user will be told *before* the step is described. They will also be given guidance on how to find out whether to perform the step.

If the user is assumed to have certain knowledge of other processes, a link to those processes are required.

