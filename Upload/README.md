Telemetry Creative Upload
=========================

Creative-upload is awkward, since it requires a number of services.

Your application will need to:

* [Log in](../LoginService/README.md) to the test system, saving the cookies the login service generates
* [Generate Tickets](#generatetickets) from the login cookie
* Look up the SRV record for `_smelter._tcp.telemetry.com`
* Check [the status](#check-status) of a file using its SHA-1 hash
* If the file hasn't been received, [upload the file](#upload-file)
* Continue to [check the status](#check-status) until the file is `DONE` or an `ERROR` occurs.

##GenerateTickets

Tickets are granted via the SOAP-based interface, but a full SOAP implementation is not required. You need to have obtained:

* [`ADVERTISER_GUID`](../Platform/CampaignService.md#getadvertisers)
* [`BRAND_GUID`](../Platform/CampaignService.md#getbrands)
* [`REGION_GUID`](../Platform/CampaignService.md#getregions)
* `FILE_SHA1_HASH` - which is the SHA1-hash of the raw [file](#formats) being uploaded.

Send an HTTP request that looks like the following to *endpointurl*`/soap/apiv03/`, e.g. `https://test5823901.telemetry.com/soap/apiv03/`: 

    Accept: text/xml
    Accept: multipart/*
    Accept: application/soap
    Content-Length: 634
    Content-Type: text/xml; charset=utf-8
    SOAPAction: "http://telemetry.com/dataapi/#GenerateTickets"

    <?xml version="1.0" encoding="UTF-8"?>
    <soap:Envelope soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"
                   xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
                   xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/"
                   xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <soap:Body>
        <GenerateTickets xmlns="http://telemetry.com/dataapi/">
          <Application>cut</Application>
          <Advertiser>ADVERTISER_GUID</Advertiser>
          <Brand>BRAND_GUID</Brand>
          <Region>REGION_GUID</Region>
          <Extra>{"tgxID":"FILE_SHA1_HASH","advertiser":"ADVERTISER_GUID"}</Extra>
        </GenerateTickets>
      </soap:Body>
    </soap:Envelope>


The response will be:

    <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
                       xmlns:ns1="http://telemetry.com/dataapi/">
      <SOAP-ENV:Body>
        <ns1:GenerateTicketsReplyMsg>
          <Tickets>TICKET_STRING</Tickets>
        </ns1:GenerateTicketsReplyMsg>
      </SOAP-ENV:Body>
    </SOAP-ENV:Envelope>

Save the `TICKET_STRING` for [checking the status](#check-status) and [uploading the files](#upload-file).

##Check Status

You will need to know the:

* [`TICKET_STRING`](#generatetickets)
* [`CREATIVE_ID`](../Platform/CampaignService.md#getcreativeseditions)

Connect to https://*SmelterEndpoint*`/process.php` by looking up the SRV record `_smelter._tcp.telemetry.com` and send the GET request:

    ?token=TICKET_STRING&edition_id=CREATIVE_ID

You will get a JSON response:

    { "error_code": 0, "status": "UNKNOWN_FILE" }

You can receive the following status:

* `UNKNOWN_FILE`: The file must be uploaded. [Upload the files](#upload-file).
* `PROCESSING`: The file is being transcoded/converted
* `STAGING`: The file exists on the staging area (and has been accepted)
* `DONE`: The file is on Telemetry's content servers and is ready for serving.
* `ERROR`: Something is wrong. Record the response JSON.

##Upload File

You will need to know the:

* [`TICKET_STRING`](#generatetickets)
* [`CREATIVE_ID`](../Platform/CampaignService.md#getcreativeseditions)
* `FILE_SHA1_HASH` - which is the SHA1-hash of the raw [file](#formats) being uploaded.

You must have a file matching [the upload specs](#formats). If you are uploading video, you will also need a thumbnail for some vendors.

Connect to https://*SmelterEndpoint*`/process.php` by looking up the SRV record `_smelter._tcp.telemetry.com` and send an HTTP POST
of the content-type `multipart/form-data` with the following fields:

* `token` - the [`TICKET_STRING`](#generatetickets) above
* `edition_id` - the [`CREATIVE_ID`](../Platform/CampaignService.md#getcreativeseditions)
* `main_file` - the [raw file](#formats)
* `thumbnail` - if the `main_file` is a video, include a JPEG `512x288` pixels.

When the file is done uploading, you will get a JSON response:

    { "error_code": 0, "status": "PROCESSING" }

You can receive the following status:

* `PROCESSING`: The file is being transcoded/converted
* `STAGING`: The file exists on the staging area (and has been accepted)
* `DONE`: The file is on Telemetry's content servers and is ready for serving.
* `BAD_HASH`: The hash in the ticket doesn't match the hash of the uploaded file.
* `ERROR`: Something is wrong. Record the response JSON.

##Formats

###Video
* **File Type:** MOV or AVI
* **Aspect Ratio:** 16:9
* **Min Dimenions:** 1280x720
* **Max file size:** 2GB
* **Min frame rate:** 23.97fps
* **Min duration:** 2seconds
* **Max duration:** 90seconds
* **Field Order:** Progressive (de-interlaced)
* **Pixel aspect ratio:** Square
* **Min Audio Sample Rate:** 44100hz
* **Video Codec:** H.264 (recommended), Quicktime Animation, or uncompressed
* **Audio Codec:** AAC or Uncompressed
* **Audio Channel:** Stereo
* **Audio Level*:** Must be -27db (+/-2db)
Please remove any leaders or extra black frames

###AS3 SWF
Suitable for Display and Companion banners.

* Uploaded SWF must not contain any clickTag code
* Preload/First SWF must contain the following code in the first-frame/constructor:

        import flash.utils.getDefinitionByName;
        try { getDefinitionByName(“Telemetry”).init(stage);}catch(e:Error){}

###JPEG
Suitable for video thumbanils, Display and Companion banners.

* No special requirements

