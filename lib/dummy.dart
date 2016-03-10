import 'dart:async' show Future;
import 'dart:io' show HttpServer, InternetAddress;

class DummyServer {
    static Future create(var cfg) async {
        var srv = await HttpServer.bind(InternetAddress.ANY_IP_V4, cfg.targetUrl.port);
        srv.listen((req) async {
            print(new String.fromCharCodes(await req.fold([], (p,v) {p.addAll(v); return p;})));
            req.response.close();
        });
    }
}


