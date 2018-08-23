[![Go Report Card](https://goreportcard.com/badge/github.com/cmacrae/poke)](https://goreportcard.com/report/github.com/cmacrae/poke) [![license](http://img.shields.io/badge/license-MIT-red.svg?style=flat)](LICENSE)
# Poke 👉
A stupid simple notifier built on [Pushover](https://pushover.net/)

## About
Poke is a little notifier program that takes JSON or YAML configuration expressing a push notification to send to a device/group of devices via [Pushover](https://pushover.net/)

It is designed to be simple, but powerful. It can read JSON or YAML from a file, or directly from `stdin`.

### From a file
Where `example.json` looks like:
```json
{
    "token": "7wUXeEnLOEVLi5jMxkxHpCGT5TMweZ",
    "recipient": "DOoPnaZ4Ya2MgyK8T4V40FctDFOpYb",
    "title": "Poke!",
    "message": "Hey check this out",
    "url": "https://golang.org",
    "url_title": "Golang",
    "attachment": "./gopher.png"
}
```

`$ poke example.json`

Or, with `example.yml`:
```yaml
---
token: 7wUXeEnLOEVLi5jMxkxHpCGT5TMweZ
recipient: DOoPnaZ4Ya2MgyK8T4V40FctDFOpYb
title: Poke!
message: Hey check this out
url: https://golang.org
url_title: Golang
attachment: ./gopher.png

```

`$ poke example.yml`

### From stdin
Poke can read YAML or JSON expressions from `stdin`.
Be it piped from the output of something else:
```
$ curl https://example.com/api/some_json_or_yaml | poke
```

Or Poke will read data directly if nothing is piped to it and it doesn't have a file argument:
```
$ poke
{
    "token": "7wUXeEnLOEVLi5jMxkxHpCGT5TMweZ",
    "recipient": "DOoPnaZ4Ya2MgyK8T4V40FctDFOpYb",
    "title": "Poke!",
    "message": "Hey check this out",
    "url": "https://golang.org",
    "url_title": "Golang",
    "attachment": "./gopher.png"
}
^D
```
*Note: `^D` here is CTRL+D - to indicate to Poke we're done*

## Verbosity
If you'd like to print some statistics from Pushover after your notification has been sent, you can use the `-v` flag to get output like the following:
```
Request id: zc47c30b-3ff2-8a92-kl89-gg7b1b77z3gt
Usage 7449/7500 messages
Next reset : 2018-09-01 06:00:00 +0100 BST
```

## Examples
Check out the [examples](examples/) for some simple scripts using Poke!

## Preview
Lockscreen                 |  Pushover
:-------------------------:|:-------------------------:
![](https://i.imgur.com/Gf0WDdY.png) | ![](https://i.imgur.com/OU1qOtK.png)

## Configuration
Poke is configured purely through the config you pass it, as shown above.

### Required parameters
The only required parameters are `token`, `recipient`, and `message`.
If you wish to exclude any of the other data, it can simply be left out.

### `url`/`url_title`
These parameters can be used to provide an easily clickable link in your notification.
`url` can be used on its own, but `url_title` requires `url`.

### `attachment`
This parameter can be used to provide an attachment in your notification.

As per [Pushover's 'Attachments' section in their API documentation](https://pushover.net/api#attachments), this must be an image.
It will be displayed inline at the bottom of your notification.

Its value should be the local filesystem path to the image; relative or absolute.
Support for remote images is coming soon! 💪

## Licensing
See the [LICENSE](LICENSE) file
