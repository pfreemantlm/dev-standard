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

    MMDMA=505
  
Will require delivery to Detroit, MI.

## ZVELOBLOCK

`ZVELOBLOCK` requires the edition not be in the given target categories. The category numbers are available [from Zvelo](https://zvelo.com).

The categories selected are stored in a base64-encoded bit-array, where set bits are blocked categories.

To compress the array, runs of zeros can be encoded as a skip. This is is an unencoded asterisk followed by the new offset encoded as
a base64 value. A sample encoder is provided in [perl](samples/b64pack.pm).

For example:

    ZVELOBLOCK=AgEI*IBAAAQ=

rejects categories 2, 9, 20, and 107.

## The PET policy

The PET policy is used to filter out a placement edition combination if a certain edition has been sheen within a certain tim period. it is in the following from

PET=300_500001_5_1_4

The first number is a time range in seconds, the second number is a placement id, and the subsequent numbers are deltas from the previous placement. So, in this instance, the placements in this policy are 500001, 500006 (500001 + 5), 500007 (500001 +5 + 1) and 500011 (500001 +5 + 1 + 4). Note that the delta encoded edition ids need to be in order (i.e., no negative deltas).

The policy will filter out a creative if it is present in both the policy string and the PET cookie and the PET cookie indicates that it was last seen within TR seconds. The PET cookie is set at adstart will be discussed a bit later. 

## The PES policy

This policy is used to filter out a placement-edition combination unless a certain edition has already been seen by the user. The PES policy has the form.

PED=500001_5_1_4

This is exactly the same as the PET policy, except now TR has been removed. The PED policy will filter out an edition unless it is present in the both the PED policy and the PET cookie. The timing does not matter. Like the PET policy, the PES policy cannot use negative deltas in its encoding.

## Frequency Capping policy (FCAP)

This policy is used to implment per-creative frequency capping. The policy is in the form 

FCAP= 300.3_1500.2

This means that this placement-edition combination will be blocked it is seem more than 3 times in 300s, or 5 (3+2) times with 1800 seconds (1500s+300s). Much like with the PES and PET policies, this is done by setting a cookie at adstart time. 

## Appendix A: The PET cookie

The PET cookie keep a list of editions and the last time they were seen. The Cookie’s key is PET_{advertiserid} e.g. for advertiser 600008 the key would be PET_600008.

This is stored in a delta, encoded form, where the first values are absolute and each following value is relative to the one that preceded it. For example, if edition 500001 was seen at 1432720100, 500003 at 1432720000 and 500004 at 1432720300 the resulting cookie would be 500001_1432720100,2_-100,1_400. When the cookie is set it is sorted in order of edition id. This is to help optimize the parsing of the cookie. 

The PET cookie is set at adstart for any placement-edition combination that has a PET policy in its policy string. A blank policy (e.g ‘&PET=’ as a substring of the policy string) will still cause the cookie to be set



