Telemetry CampaignService - uploadAssignment Policies
=====================================================

One or more `"Policies"` can be assigned to a combination of Placement-Edition, during an `uploadAssignments` request in the [Campaign Service](./CampaignService.md) system. These are encoded as an RFC3986 "query" without the leading question-mark. Keys and values must be percent-encoded as in URLs.

    key=value&key=value ...

Keys are documented below.

## MMCOUNTRY

Require that the client IP addres is in the specified country. Note the codes are not ISO3166 codes but indexes in the Maxmind country list
hardcoded in [GeoIP.c](https://github.com/maxmind/geoip-api-c/blob/master/libGeoIP/GeoIP.c#L105), and reproduced below:

    AP EU AD AE AF AG AI AL AM CW AO AQ AR AS AT AU AW AZ BA BB BD BE
    BF BG BH BI BJ BM BN BO BR BS BT BV BW BY BZ CA CC CD CF CG CH CI
    CK CL CM CN CO CR CU CV CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER
    ES ET FI FJ FK FM FO FR FX GA GB GD GE GF GH GI GL GM GN GP GQ GR
    GS GT GU GW GY HK HM HN HR HT HU ID IE IL IN IO IQ IR IS IT JM JO
    JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV
    LY MA MC MD MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ
    NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN
    PR PS PT PW PY QA RE RO RU RW SA SB SC SD SE SG SH SI SJ SK SL SM
    SN SO SR ST SV SY SZ TC TD TF TG TH TJ TK TM TN TO TL TR TT TV TW
    TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT RS ZA ZM ME
    ZW A1 A2 O1 AX GG IM JE BL MF BQ SS O1

For example:

    MMCOUNTRY=255

Will target only the USA. 

## MMDMA / DMA

Consider the placement/edition combination "in-target" if the client IP address is in the specified DMA (designated market area).

`MMDMA` requires the edition is not "in-target" which can be used for region-targetted creatives. `DMA` only reports
whether the delivery was "in-target". If the trafficking sheet has multiple placements with separate `DMA` then the buyer
expects the vendor to target the media. If the trafficking sheet has a single placement with multiple creatives having separate DMA,
then the buyer expects Telemetry to target (and you should use `MMDMA`).

Note that the regions are usually listed on trafficking sheets as a city/state combination, but the numeric code is required here.
You can download the current list from [Google](https://developers.google.com/adwords/api/docs/appendix/cities-DMAregions).

For example:

    MMCOUNTRY=505
  
Will require delivery to Detroit, MI.

## ZVELOBLOCK

`ZVELOBLOCK` requires the edition not be in the given target categories. The category numbers are available [from Zvelo](https://zvelo.com).

The categories selected are stored in a base64-encoded bit-array, where set bits are blocked categories.

To compress the array, runs of zeros can be encoded as a skip. This is is an unencoded asterisk followed by the new offset encoded as
a base64 value. A sample encoder is provided in [perl](samples/b64pack.pm).

For example:

    ZVELOBLOCK=AgEI*IBAAAQ=

rejects categories 2, 9, 20, and 107.


