Architecture
============

## Web-based Applications

The architecture of web-based applications should emphasize transport-level extensibility.

It is easier to add a slick AJAX-y interface is to a well-designed platform, than it is to extract a usable public API from a slick AJAX-y interface.

### GET

Pages that "get" things must not make changes to any database. They may log performance/stats information.

### POST

Pages that make changes must not display anything- only send a redirect to a desired page.

Clients can be expected to send `application/x-www-urlencoded` content or `multipart/form-data` but not JSON or XML.

### Pixels

Applications that log (but do not report) may use a GET interface, respond either HTTP 204 (No Content) or a blank gif image (older browsers). They may
log information but may not respond with any meaningful information. This is suitable for user-side logging.

### Authentication

The application will assume the user is already authenticated.

### Authorization

The application will expose authorization realms using the URL. For example, pages that have "editing" features will have `/edit/` in the URL. This makes it possible to filter at the web server.


## Processing Applications

Programs take their arguments via the command line or via environment variables.

They do not use configuration files (but may read from "lists of things" such as a list of hostnames to connect to).

Credentials for remote services can be read from a file that is named as an argument.

Log to standard error.

Don't Daemonize. Assume the caller will put your processing application into the background with `&` if that is what they intend.

Don't require root. Your program doesn't require root.

