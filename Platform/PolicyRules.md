Telemetry CampaignService - uploadAssignment Policies
=====================================================

One or more `"Policies"` can be assigned to a combination of Placement-Edition, during an `uploadAssignments` request in the [Campaign Service](./CampaignService.md) system.

The format of the value is that of a GET-line argument, eg:

    MMCOUNTRY=255&DMA=123

There are currently 3 supported types of Policy, detailed below:

## MMCOUNTRY

This will ensure tags are only served to client IP addresses that are identified to be within the provided country ID, via geolocation. For example:

    MMCOUNTRY=255

Will target only the USA. 

* TODO: where do we get these values from?


## MMDMA / DMA

This will assign one or more DMA targets to the Placement-Edition combination., eg:

  MMCOUNTRY=505
  
Will target only Detroit, MI

* TODO: where do we get the values from?
* TODO: document encoding/offsetting

Note that `MMDMA` will result in blocking/blacklisting ad requests when the DMA is not one of the assigned values; whereas `DMA` is used only for reporting against what actually happened.

## ZVELO

* TODO: Document this policy...
