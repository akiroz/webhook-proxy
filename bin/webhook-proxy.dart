import '../config.dart' show Config;
import 'package:webhook_proxy/proxy.dart' show ProxyServer;
import 'package:webhook_proxy/dummy.dart' show DummyServer;

void main() async {
    var cfg = new Config();
    DummyServer.create(cfg);
    ProxyServer.create(cfg);
}
