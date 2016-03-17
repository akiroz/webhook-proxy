# webhook-proxy

proxy for github's webhook that supports
issue title and description update events

## Install

1. install [dart SDK](https://www.dartlang.org/downloads/)
2. `git clone https://github.com/akiroz/webhook-proxy.git`
3. `cd webhook-proxy/`
3. `pub get`

## Usage

* edit `lib/config.dart`
* start server with `dart bin/webhook-proxy.dart`
* or daemonize with `nohup dart bin/webhook-proxy.dart >proxy.log &`

## Limitations

* assumes actor of title or description changes as the creator
* cannot detect changes made in less than one polling interval
* cannot detect changes in closed issues
