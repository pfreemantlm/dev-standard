Doubleclick macros occasionally appear in tracking URLs and are [documented by Google](https://support.google.com/dfp_premium/answer/1242718?hl=en). If these ids are to be served by Telemetry (e.g. as a tracking pixel)
then the macros have to be expanded ahead of time.

<table>
<thead><tr><th>DoubleClick</th><th>Description</th><th>Suggestion</th></tr></thead>
<tbody>
<tr><td>%%CACHEBUSTER%%</td><td>Should be random to ensure the URL is always unique</td><td>Telemetry's player recognises [timestamp] which can be used.</td></tr>
<tr><td>%%SCHEME%%</td><td>Should be https: or http: as appropriate</td><td>Telemetry's player automatically assumes all http:// urls can be translated to https:// but the TagExporter verifies this. Use https:// if in doubt.</td></tr>
<tr><td>%eaid!</td><td>Line item ID</td><td>Telemetry Edition Id</td></tr>
<tr><td>%eadv!</td><td>Advertiser ID</td><td>Telemetry Advertiser Id</td></tr>
<tr><td>%ebuy!</td><td>Order ID</td><td>Telemetry Campaign Id</td></tr>
<tr><td>%ecid!</td><td>Creative ID</td><td>Telemetry Creative Id</td></tr>
<tr><td>%eenv!</td><td>Environment (tag type) indicator: i for iframe, j for JavaScript</td><td>Probably an error if you see this. Always use <tt>j</tt></td></tr>
<tr><td>%epid!</td><td>Placement ID</td><td>Telemetry Placement Id</td></tr>
<tr><td>%esid!</td><td>ID of the highest-level ad unit above the ad unit where the line item is being served</td><td>Telemetry Placement Id</td></tr>
</tbody></table>

