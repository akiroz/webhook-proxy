
import 'package:di/di.dart' show ModuleInjector, Module;

import 'package:webhook_proxy/config.dart' show Config;
import 'package:webhook_proxy/scheduler.dart' show Scheduler;
import 'package:webhook_proxy/watcher.dart' show Watcher;
import 'package:webhook_proxy/proxy.dart' show ProxyServer;
import 'package:webhook_proxy/dummy.dart' show DummyServer;

void main() {
    var di = new ModuleInjector([new Module()
            ..bind(Config)
            ..bind(Scheduler)
            ..bind(Watcher)
            ..bind(ProxyServer)
            ..bind(DummyServer)
    ]);
    di.get(DummyServer).start();
    di.get(ProxyServer).start();
    di.get(Watcher).start();
}


