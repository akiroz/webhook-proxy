
import 'dart:io' show HttpClient;
import 'package:di/di.dart' show ModuleInjector, Module;

import 'package:webhook_proxy/config.dart' show Config;
import 'package:webhook_proxy/scheduler.dart' show Scheduler;
import 'package:webhook_proxy/watcher.dart' show Watcher;
import 'package:webhook_proxy/proxy.dart' show ProxyServer;

void main() {
    var di = new ModuleInjector([new Module()
            ..bind(HttpClient, toFactory: ()=> new HttpClient())
            ..bind(Config)
            ..bind(Scheduler)
            ..bind(Watcher)
            ..bind(ProxyServer)
    ]);
    di.get(ProxyServer).start();
    di.get(Watcher).start();
}


