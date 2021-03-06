
import 'dart:async' show Future;
import 'dart:io' show HttpServer, HttpClient, 
       HttpRequest, HttpClientRequest, InternetAddress,
       HttpClientResponse;

import 'package:webhook_proxy/config.dart' show Config;

typedef void Proxy(HttpRequest);

class ProxyServer {
    Config cfg;
    HttpClient client;
    ProxyServer(this.cfg, this.client);

    /// start HTTP proxy server
    Future start() async {
        var srv = await HttpServer.bind( InternetAddress.ANY_IP_V4, cfg.bindPort );
        srv.listen( proxyRequestTo(cfg.targetUrl) );
    }

    /// Proxies [HttpRequest]s to speciflied URL
    /// return a consumer function `(HttpRequest) => void`
    Proxy proxyRequestTo(Uri url) {
        return (HttpRequest req) async {
            try {
                HttpClientRequest pxy = await client.postUrl(url);
                pxy.headers.clear();
                req.headers.forEach(pxy.headers.set);
                pxy.headers.set('host', url.authority);
                await pxy.addStream(req);
                HttpClientResponse rsp = await pxy.close();
                req.response.headers.clear();
                rsp.headers.forEach(req.response.headers.set);
                await req.response.addStream(rsp);
                req.response.close();
            } catch(e) {
                // slient fail
            }
        };
    }
}
