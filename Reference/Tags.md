Tags
====

A "tag" is an industry term for some bit of interchange-configuration.

The exact format of a tag varies wildly by creative-type and by tracking technology.

One of the functions that an ad trafficker performs is copying (and translating) these
tags between systems, but confusingly, the *output* of an ad server (that is used by
a video player, ad exchange, or web browser) can *also* be called a tag.

## Video

For video, almost every ad platform uses [VAST](http://www.iab.net/guidelines/508676/digitalvideo/vsuite/vast).

An ad trafficker will be familiar with [VPAID](http://www.iab.net/guidelines/508676/digitalvideo/vsuite/vpaid) creatives (generally SWF but sometimes JavaScript)
and with "linear video" creatives (generally: WEBM, MP4 and/or FLV).

On most ad platforms, the trafficker works with VAST URIs. Telemetry VAST URIs look like this:

    http://spc--ceffiflemepegfadkfdeihed.telemetryverification.net

Note the sequence after `spc--` and is an encoded [placement ID](./Campaigns.md#Placements). Some platforms require VAST Wrappers, which look like this:

    <?xml version="1.0">
    <VAST version="2.0">	
      <Ad id="1">
        <Wrapper>
          <AdSystem>Telemetry</AdSystem>
          <VASTAdTagURI>http://spc--ceffiflemepegfadkfdeihed.telemetryverification.net</VASTAdTagURI>
          <Impression><![CDATA[about:blank]]></Impression>
        </Wrapper>
      </Ad>
    </VAST>

The ad trafficker will typically edit this to insert tracking macros that the vendor is interested in.


## Display 

For display, an ad trafficker will be familiar with several different creative formats
that are designed to slot in to a media placement unit (MPU).

All formats are dependant on the "size of the unit", and the trafficker may be required
to configure their systems to target platforms, browsers, javascript-enabled users,
and so on.

Telemetry requires *for all Display formats*:

* JavaScript
* Adboe Flash (min: Flash version 10)

### Standard IFrame

A standard IFrame format can be trafficked as a URI, or as a fragment of HTML:

    <iframe src="IFRAME_TARGET"></iframe>

The ad trafficker will typically edit this to insert additional HTML for their
own tracking.

### Standard JavaScript Tag

A standard JavaScript tag is almost always trafficked as a fragment of HTML
beginning with a script tag, and containing a noscript-fallback:

    <script src="SCRIPT_TO_PULL"></script>
    <noscript><a href="CLICK_URI"><img src="IMAGE_FALLBACK"></a></noscript>

One particular variant of the JavaScript tag is the IAB Friendly IFrame which
involves hosting an iframe on the same site as the publisher and using
`document.write()` to insert code like the above into the page. This allows
the frame to manpulate (e.g. expand and position) itself by modifying the
`window.frameElement` variable.

Another variant uses something called an "IFrame Buster" which is a bit of
code saved on the publisher site that the tag can communicate with. This
involves a bespoke integration with Telemetry that the creative has to be
aware of.

The ad trafficker will typically edit this to insert additional HTML for their
own tracking.

# Testing

Telemetry ad servers support an HTTP Cookie:

    Cookie: R=http://xxx

where "xxx" is the name of the server that tags will be fetched from. This is
a useful debugging aid as tags can be created/exported on your test server,
and you can pull them with any web browser.

Note that "xxx" must be a registered Telemetry server (i.e. you cannot route
live traffic to your laptop).

Video can be reliably tested using [JWPlayer](http://static.openvideoads.org/tag-validator/jwplayer.html)

Display can be reliably tested by saving the tag in a file and calling the file via a web server.
