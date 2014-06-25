Telemetry LoginService
======================

Applications require a number of cookies to "log in" to the platform.

One way to get these cookies using the LoginService:

1. Prepare an HTTP POST transaction to the *endpointurl*`/Security/password?callback=curl`
1. Set the HTTP Referer to "https://gateway.telemetry.com/"
2. Set the POST content will be "u={urlencoded username}&p={urlencoded password}"
3. Verify that the output of the login *does* contain the string `NeedsLogin.finish`

An example shell-script using CURL follows:

    curl -s --cookie-jar "cookie-jar" \
         -H 'Referer: https://gateway.telemetry.com/' \
         --data "u=$username&p=$password" \
         "https://$url?callback=curl"

An acceptable test endpoint is: https://test5823901.telemetry.com

A successful login looks like this:

    window.IPL="192.168.1.1";Decorate('p@test5823901');NeedsLogin.finish();
    if(console.info)console.info('url:'+"\/Security\/password?callback=curl");
    if(console.info)console.info('-------');

An unsuccessful login looks like this:

    window.IPL="192.168.1.1";Decorate('p@test5823901');RequireCredentials("Password");
    NeedsLogin(null);
    if(console.info)console.info('url:'+"\/Security\/password?callback=curl");
    if(console.info)console.info('-------');

There may be other lines and the exact format may change. Please scan for the exact string suggested.

