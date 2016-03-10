import 'dart:io';
import "package:test/test.dart";
import 'package:webhook_proxy/proxy.dart';
import '../config.dart';

void main() {
    test("proxy server", () async {
        var cfg = new Config();
        var srv = await HttpServer.bind(InternetAddress.ANY_IP_V4, cfg.targetUrl.port);
        print('echo target started...');
        srv.listen((req) async {
            req.response.headers.clear();
            req.headers.forEach(req.response.headers.set);
            await req.response.addStream(req);
            req.response.close();
        });
        await ProxyServer.create(cfg);
        print('proxy started...');
        var req = await new HttpClient().get('localhost', cfg.bindPort, '/');
        req.headers.set('X-TESTING', 'foobar');
        req.headers.contentLength = 32;
        req.write('{"hello":"world","nums":[1,2,3]}');
        var rsp = await req.close();
        expect(rsp.headers['X-TESTING'][0], equals('foobar'));
    });
}
