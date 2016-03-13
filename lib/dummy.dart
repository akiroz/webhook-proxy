
import 'dart:async' show Future;
import 'dart:io' show HttpServer, InternetAddress;

import 'package:webhook_proxy/config.dart' show Config;

class DummyServer {
    Config cfg;
    DummyServer(this.cfg)
    Future start() async {
        var srv = await HttpServer.bind(InternetAddress.ANY_IP_V4, cfg.targetUrl.port);
        srv.listen((req) async {
            print(new String.fromCharCodes(await req.fold([], (p,v) {p.addAll(v); return p;})));
            req.response.close();
        });
    }
}


