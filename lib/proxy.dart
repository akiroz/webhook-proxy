import 'dart:async' show Future;
import 'dart:io' show HttpServer, HttpClient, 
       HttpRequest, HttpClientRequest, InternetAddress,
       HttpClientResponse;

typedef void Proxy(HttpRequest);

class ProxyServer {
    /// Proxies [HttpRequest]s to speciflied URL
    /// return a consumer function `(HttpRequest) => void`
    static Proxy proxyRequestTo(Uri url) {
        return (HttpRequest req) async {
            HttpClientRequest pxy = await new HttpClient().postUrl(url);
            pxy.headers.clear();
            req.headers.forEach(pxy.headers.set);
            await pxy.addStream(req);
            HttpClientResponse rsp = await pxy.close();
            req.response.headers.clear();
            rsp.headers.forEach(req.response.headers.set);
            await req.response.addStream(rsp);
            req.response.close();
        };
    }
    /// create HTTP proxy server with given config
    static Future create(var cfg) async {
        var srv = await HttpServer.bind( InternetAddress.ANY_IP_V4, cfg.bindPort );
        srv.listen( proxyRequestTo(cfg.targetUrl) );
    }
}
