Notify API
==========
The notify API allows a backend ("Master") service to securely receive and reply to messages sent by an external party ("Client") upload.

## Client side

The client is issued two encrypted tokens, at least 42 characters in length:

* `Authentication Cookie`, beginning "KA", which corrosponds to a registered user in the Telemetry Gateway system
* `Circuit Cookie`, beginning "KC", which corrosponds to a valid Mailbox "circuit" which can be subscribed to by the Master service.

They are also provided with:

* `Endpoint URL`, which is combined with the above keys to form the destination HTTP POST URL, in the format:

    `[ENDPOINT]/Dispatch/[KA COOKIE]/[KC COOKIE]`

Messages themselves should be URL-encoded.

Example client POST request:

    curl -i -X POST --data-urlencode "your message here" https://notify-sample.telemetry.com/Dispatch/KAxyzxyzxyzxyzxyzxyzxyzxyzxyzxyzxyzxyzxyzzz/KCabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdee


The response to this POST, if successfully handled, will be the body of the message from a [MailboxPost](MailboxPost) reply POST from the Master, in the format:

    [HEADERS]
    [HEADERS]
    [-blank line-]
    [MESSAGE ID HEADER]
    [-blank line-]
    [-blank line-]
    [MESSAGE BODY]

Example Response: 

    HTTP/1.1 200 OK
    Server: nginx/1.6.2
    Date: Tue, 21 Jul 2015 17:35:04 GMT
    Content-Type: text/plain;charset=UTF-8
    Content-Length: 88
    Connection: keep-alive
    X-Saw-User: atest@telemetry
    Access-Control-Allow-Origin: *
    
    Header: value
    Header: value
    Header: value
    
    your message here


## Master side

The master is issued with:

* `Endpoint URL`, which is where the Master connects to in order to both receive and reply to messages.
* `Secret Token`, which corrosponds to the Mailbox they wish to subscribe to. It should be the value of a parameter "secret=" and the whole argument should be URL-encoded.

Both of these are combined in the following Mailbox calls:


#### MailboxListen

An HTTP POST to `[ENDPOINT]/MailboxListen/' subscribes to the Mailbox associated with the `secret`, and requires the following URL-encoded parameters:

* `secret` - the Secret Token described above
* `last` - the ID of the last message seen (format of message IDs is described below)

The *Referer* header must also be set, matching the `Endpoint URL`.

Example POST:

    curl -i -X POST --data-urlencode "secret=my_secret_token" --data-urlencode "last=20150721150420.22587_1.sample-server" \
      -H "Referer: https://notify-sample.telemetry.com" \
      "https://notify-sample.telemetry.com/MailboxListen/"
      

A 200 response from the server contains the full message as sent by the Client; both headers and *base64-encoded body*, in the following format:

    [Headers]
    [Headers]
    [-blank line-]
    [base64 encoded body]

Example response:

    HTTP/1.1 200 OK
    Server: nginx/1.6.2
    Date: Tue, 21 Jul 2015 17:28:37 GMT
    Content-Type: text/plain;charset=UTF-8
    Content-Length: 68
    Connection: keep-alive
    X-Message-Id: 20150721172837.7620_1.sample-server
    Content-Transfer-Encoding: base64
    X-Telemetry-User: atest@telemetry
    User-Agent: curl/7.38.0
    Host: sample-server
    Accept: */*
    Access-Control-Allow-Origin: *
    
    your%20message%20here
    
These headers contain useful information for the Master, such as:

* `X-Message-Id` - the ID of the message received; in the format: [timestamp][process number]_[count].[server]
* `X-Telemetry-User` - the Telemetry Gateway user associated with the Client upload request

**Note**: If no message has been sent by a User within 10 minutes of a /MailboxListen/ request, the endpoint will return a 502 "Bad Gateway" error. The Master should reconnect with another `MailboxListen` request.


### MailboxPost

When the Master receives and handles a message, a reply should be made with an HTTP POST to `[ENDPOINT]/MailboxPost/`, along with the following URL-encoded parameters:

* `secret` - the Secret Token described above
* `id` - the ID of message we are replying to
* `headers` - the headers of the reply to PASS ON to the Client; this is not the same as the headers we are sending to the Endpoint.
* `data` - the body of the reply

The *Referer* header must also be set, matching the `Endpoint URL`.

    curl -X POST --data-urlencode "secret=my_secret_token" \
        -H "Referer: https://notify-sample.telemetry.com" \
        --data-urlencode "id=20150721172837.7620_1.sample-server" \
        --data-urlencode "headers=`$HEADERS_GO_HERE`" \
        --data-urlencode "data='Message received loud and clear'" \
        "https://notify-sample.telemetry.com/MailboxPost/"

This will then form the message that the Client receives in reply to their original message POST. 
