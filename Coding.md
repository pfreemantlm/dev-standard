Coding Standard
===============

# Restrictions and Limitations

## File Sizes

Functions must not span a screenful (80x25).

Unless classes are "mocking classes" or "proxy classes", create no more than one class per file.

## Indention

A tab is 8 spaces.

Languages that emphasize a continuation-passing style (JavaScript) should use two spaces instead of a tab.

Python may use the guidance in PEP8 and use four spaces for indention (no tabs).

## Magic

Magic numbers are frowned upon. Define and document constants.

## Entry and Exit

Use as many return statements as there are conditions for exit; do not go through contortions and nest if statements to just to have a single return.

Dynamic exit (for example via an exception) must be caught; do not use uncaught exceptions to signal errors.

## Monikers

All names chosen for variables, classes, functions, and etc., within a project should match the following naming convention:

### General notes about Length and Choice

* Chose names proportional to their accessibility; Variables that are accessible globally (like class names) should be longer than variables that are only accessible within a pageful.
* Static functions and variables are global functions because they represent global state
* Name what it does, not what it is.

### Constants and Macros

* Use `ALL_UPPERCASE_WORDS`
* Prefer C++ templates if possible
* Code-rewriting for deployment of systems should use double-at for templates, e.g. `@@VERSION@@`

### Classes and Top-Level Functions

* CapsCase e.g. `ReportJournalTopStories`
* In languages that emphasize a continuation-passing style, braces belong on the same line. In other languages, braces on a line by themselves.
* Interfaces begin with the letter "I" e.g. `ILoader`

### Methods

* CapsCase e.g. `GetTimestamp`
* Braces on the same line
* Method prototypes shall include variable names as well as types.
* Methods that do not access any member variables should be defined as static
* Methods should be defined with the most restrictive access level possible; i.e. most methods should be private.

### Local Variables and Arguments echo their type

* `iLastOffset` is an integer, contains the last offset of something.
* `sFirstName` is a string, and contains a first name.
* `cRequest` is a class-instance, and contains a Request of some kind.
* `aParts` is an array of parts.
* `eColour` is an enumeration of colours.
* `fSoundlevel` is a floating-point sound level.
* `uLimit` is an unsigned limit (C/C++/C# only)
* `dNow` is a date object, and contains now.
* `bFirst` is a boolean (true/false) and represents first.
* `hFile` is a handle to a file.
* `zName` is a variant (mixed) type.
* Names echo their type as the first letter (s for strings, c for objects, i for integers
* `i` and `j` are acceptable single-character variables for loops, etc.
* Each variable shall be defined on a separate line.

### Members indicate their visbility

* `pcParent` is a *private or protected class-instance*
* `msUser` is a *public* string.
* Almost all member variables shall be defined as private, with the exception of data only (i.e. with no methods defined) classes

Note that PHP "constants" are members, but follow the constant rule of being all-uppercase.

### Databases

* Database names begin with `db` e.g. `dbTagTug`
* Databases that are not replicated between datacenters have the name of the datacenter embedded, e.g. `dbTGateReadOnly_SfoLive`

### Database Tables

* Table names begin with `tb_` and then use CapsCase, e.g. `tb_CampaignsPlacements`
* Table names that are experimental should begin with `tb_x` and then use `CapsCase` e.g. `tb_xFile`

### Database Columns

* `ch_` for character/string
* `d_` for dates
* `e_` for enums
* `f_` for floats
* `iu_` for unsigned integers
* `pk_` for the primary key
* `fk_` for a foreign key

# Comments and Documentation

Commenting within code is the warning sign to tell future editors of the code about potential pitfalls or gotcha's.
It should describe any special decisions made which are not obvious by looking at the code. It may also be used to briefly summarise sections of the code.

* Never try to explain how your code works in a comment; it's much better to write the code so that the working is obvious, and it's a waste of time to explain badly written code.
* The PHPDoc/NaturalDocs header should explain what your function does. The code should be self explanatory as to how it does it. If you are using a particularly complex algorithm, explain it with a brief comment block. 
* Within PHP, class member variables should have PHPDoc comments describing their type; this assists auto-completion in many IDEs. 
* If everything needs to be commented, this means that the code is not clear, and the names or design is bad. It's time to rethink.
* Always think about how you can make the function of the code be the comments.
* `ASSERT` is an excellent "executable comment"

Do not *ever* mark code as `TODO`.

## Fixups and Bodging

Decorate code as a BODGE when you have to do some kind of data-specific fix for some special case. 

Always be aware of the bodges we have installed: They aren't just an indicator of where we have failed to understand the use case,
but they're also a clue to the kinds of flexibility we need more of.

# Avoiding Pitfalls

## Don't waste energy

Do not daemonize, syslog, or parse configuration files.

## Crash Early, Crash Often

A dead program normally does a lot less damage than a crippled one.

This means turning on fatal error signalling, throwing exceptions, and generally aborting/`LFATAL`ing as soon as possible.

With API design: If programmers should call `PSQL_Init()` then make all of the other routines crash if they don't.

If programmers should subclass from `LibReportTelemetryCustomer` instead of `LibReportCommon`, then make the latter crash.

You can always add edge cases and test for unexceptional values later.

## Corollary: Assume it will crash

If your program can survive a `kill` -9 without destroying data, then it can survive far worse. Problems can happen when programs are deployed into the wild, but they must never compromise data integrity or Commercial.

## Write lots of small programs

Breaking your program into a bunch of cooperating small programs means that you can test the parts independently. You might also be able to reuse them.

## MySQL is not a messaging point

Do not store "events", "logs" or "sensor" data in MySQL. It's inappropriate. Use the sensor interface instead, and have the Infrastructure team cook up a Nagios check on the sensor.

## Implement IPC on streams

Named pipes are an excellent inter-process communication mechanism. The kernel already locks and serializes writes that are smaller than a PIPE_BUF, so there's no need for additional locking if your messages are small.

