#Terminology

This document may provide general guidance to programmers unfamiliar with media-agency terms.

##Banner Video

This is a [Display unit](#Display) that someone has served [Video](#Video) into.

[Companion](#Companion) banners are *almost never* Banner Video units.

Banner Video usually starts paused, or auto-playing with the sound muted and will only play (audio) when clicked. Banner Video that starts automatically with the sound on is usually a trafficking mistake.

##Campaign

From a technical point of view, a campaign is the set of placements+creatives(+[companion creatives](#Companion)) that are scheduled to run over a given time range.

Campaigns are planned by week, month, by quarter, and even by year.

##Campaign Year

The "campaign year" of a campaign is the calendar year that the majority of the campaign is in.

Telemetry partitions customer data by campaign year.

Most of the time, you can use the current year, *but this will be confusing* near the end of the calendar year as e.g. 2014 January campaigns
actually started in December for one advertiser, and 2013 Q4 campaigns actually ended in 2014 January for another.

Below is a suggested algorithm:

1. Scan all time-ranges in a media plan.
2. If all of the time ranges are within a single calendar year, *use that year*.
3. Collect the "start dates" and find the *mode* year; if it is *before* the midpoint of the month, *use this year*.
4. Collect the "end dates" and find the *mode* year; if it is *after* the midpoint of the month, *use this year*.
5. Count the days in each year, use the year with the most represented days

Examples:

<table><thead><tr><th>Start</th><th>End</th><th>Campaign Year</th><th>Rule</th></tr></thead><tbody>
<tr><td>2013-11-01</td><td>2013-12-02</td><td>2013</td><td>2</td></tr>
<tr><td>2013-12-03</td><td>2014-01-02</td><td>2013</td><td>3</td></tr>
<tr><td>2013-12-16</td><td>2014-01-31</td><td>2014</td><td>4</td></tr>
<tr><td>2013-12-16</td><td>2014-01-02</td><td>2013</td><td>5</td></tr>
</tbody></table>

##Click Tracking

Not to be confused with [clickthrough](#Clickthrough). Click tracking refers to measuring the click itself.

For pixel-integrated placements there are technological limitations that prevent more than one click tracking pixel from being used, so many click pixels can be configured to redirect
to some target using a macro. Telemetry recognises the `%la` macro in chaining pixels together automatically.

##Clickthrough

Clickthrough refers to the target of a click.

Clicking an ad should take the user to another site. It should open in a new window or tab if possible.

*Clickthrough* tracking is always done using redirects and is possible if the *clickthrough* pixel has a `%la` macro which facilitates chaining pixels together.

##Companion
Also referred to as a "Companion Creative" or "Companion Banner". These are [display](#Display)-banners which may
accompany the video unit.

Agencies use a couple strategies with companion banners:

#####Plan them like placements

<table><thead><tr><th>Placement</th><th>Type</th><th>Creative Name</th></tr></thead><tbody><tr><td>RON A2+</td><td>Video</td><td>MOV_2014.MOV</td></tr> <tr><td>RON A2+</td><td>Companion</td><td>banner.png</td></tr></tbody></table>

If the agency plans as placement, you need to identify which companion belongs to which placement.  Sometimes the placements will have the name in common (or have some common prefix).  Other times, the creative name will have some common prefix.
Sometimes you will have a "link" column. This might be referred to as a "companion series" or a "concept":

<table><thead><tr><th>Weight</th><th>Placement</th><th>Type</th><th>Creative Name</th><th>Series</th></tr></thead><tbody><tr><td>100</td><td>RON A2+</td><td>Video</td><td>MOV_2014.MOV</td><td>1</td></tr> <tr><td>100</td><td>RON A2+</td><td>Companion</td><td>banner.png</td><td>1</td></tr></tbody></table>

The benefit to this approach, is that it is more compact when considering an N:M weighted rotation where some N placements will have M companions between them and the weights will be in common.

#####Plan them like creatives

<table><thead><tr><th>Placement</th><th>Type</th><th>MOV_2014.MOV</th><th>banner.png</th></tr></thead><tbody><tr><td>RON A2+</td><td>Video</td><td>100</td><td>100</td></tr></tbody></table>

Telemetry always treat companions as a kind of creative. This is more straightforward as it is easy to tell which companion belongs to which placement.

##CPC

Cost-per-click. This is a **Cost Structure**. It refers to the purchase-price for every click.

##CPM

Cost-per-mille. This is a **Cost Structure**. It refers to the purchase-price for every 1,000 [impressions](#Impression).

##Creative
This is a technical term referring to the video or image unit presented in the ad.

Creatives have a *filename* that would be matched against the Telemetry Platform.

##Display
This is a technical term.  Display advertising refers to ad delivered into a page, as opposed to within a video stream.

Display advertising includes banner ads, but is usually distinguished from rich media units which might expand or interact with the user in some way.

Display units usually have standard sizes such as `300x250`, but they can *technically* be of any size.

##Impression

This is a technical term. It refers to when the ad is served and presented to the user.

This may be a billable point.

##Integration (type)

This is a Telemetry-term. Media Agencies are not usually familiar with the Integration type.

Integration refers to the connection between Telemetry's ad server and the Vendor's ad server (and/or ad player).

* IAB standard VAST+VPAID - referred to as `VPAID` and used for most Video.
* IAB standard VAST Linear - referred to as `Mid Level`
* `Pixel` - no integration (just a list of pixels)
* `Hulu` - should only be used for "Hulu" as a [Vendor](#Vendor) or if the placement is "on Hulu".



##Media Plan

An Ad Agency will produce a media plan and trafficking sheet.

In digital ad campaigns, these are often presented in a combined format.

The goal of the media plan is to indicate which campaigns will run over which timeframe, to which [Placement](#Placement)s.

##Network

This is a technical term. It refers to a collection of publishers or placement-opportunities that have been sold in aggregate.

Sometimes a network is a real-time-bidding exchange where the opportunity is selected in real-time with software-agents bidding
on individual impressions.

Telemetry always refers to networks as [Vendors](#Vendors).


##Pixel

A pixel refers to a URL that when called returns a blank gif (or sometimes a HTTP 204 response).

Most ad tracking is done with pixels since it is technologically simple to implement, performs well under high load, and has no
cross-domain considerations.

##Placement

A Placement is a digital analogue of a *space* to serve an ad. It isn't necessarily a single box that an ad will show in, as especially Video placements often consist of several creatives that are designed to be delivered simultaneously.

##Publisher

A publisher is someone who operates a site.

Telemetry always refers to publishers as [Vendors](#Vendors).

##Rich Media

Rich Media refers to placement/creatives that interacts with the user and page. There are some standard formats (like expandables)
and some exotic formats (like whole page takeovers).

##Rotation

In a media campaign, a number of creatives will be sent to a given placement *on rotation*. The rotation simply refers to all of those
creatives *considered together*. They may be *weighted* so one creative is shown more often than another. This weight is usually presented
as a percentage (50%/50%) or as a ratio. If there is no weighting supplied, it is said to have *even weighting*.

A rotation will often be limited to a specific time-frame (start/end) dates. These are always in the campaign-local timezone.

A Placement+Creative combination with a zero-weight is not intended to run.

##Site

See [Publisher](#Publisher).

##Tag

Tag is a technical term. It identifies a given placement (or sometimes a placement+creative combination). It might be unique to a particular integration-type.

It is not to be confused with the *placement itself*, as the tag might have a technological component.

VAST and VAST+VPAID tags look like URIs or like XML fragments, e.g.

    http://spc--cedghgcfiglejfkfchpgkfbf.telemetryverification.net
    
or:

    <?xml version="1.0" ?>
    <VAST>
      <Ad>
        <Wrapper>
	      <AdSystem>Telemetry</AdSystem>
          <VASTAdTagURI>http://spc--cedghgcfiglejfkfchpgkfbf.telemetryverification.net</VASTAdTagURI>
          <Impression><![CDATA[about:blank]]></Impression>
        </Wrapper>
      </Ad>
    </VAST>

Telemetry-Hulu tags are small string of text, e.g.

    cedghgcfiglejfkfchpgkfbf

##Tracking Level

This is a Telemetry-term. See [Integration](#Integration).

##Trafficking Sheet

An Ad Agency will produce a media plan and trafficking sheet.

In digital ad campaigns, these are often presented in a combined format.

The goal of the trafficking sheet is to indicate which creatives should be run on which placements (and at which time). It might also include third-party tracking pixels that should be fired for specific events, such as:

* [Impression](#Impression) tracked as **Ad STart**
* **Click Event** which refers to [Click](#Click)
* **Clickthrough Landing** which is a [Clickthrough](#Clickthrough)
* **Ad Completion** which is an ad reaching 100%-complete (also: Viewthrough)
* **Mouse Over**

##Video
*As distinguished from Display*. A video placement has a video creative. It might have one or more [companion banners](#Companion) which will be served from the same [Tag](#Tag).


##Weight
See [Rotation](#Rotation).
