
import 'dart:async' show Future;
import 'dart:io' show HttpServer, InternetAddress;

class DummyServer {
    static Future start(int port) async {
        var srv = await HttpServer.bind(InternetAddress.ANY_IP_V4, port);
        srv.listen((req) async {
            print(req.headers);
            print(new String.fromCharCodes(await req.fold([], (p,v) {p.addAll(v); return p;})));
            req.response.close();
        });
    }
}

void main() {
    DummyServer.start(8001);
}
