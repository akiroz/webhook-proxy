
import 'dart:async' show Future;
import 'dart:convert' show UTF8, JSON;
import 'dart:io' show HttpClient;

import 'package:webhook_proxy/config.dart' show Config;
import 'package:webhook_proxy/scheduler.dart' show Scheduler;

class Watcher {
    Config cfg;
    Scheduler sched;
    Map<int, String> titles;
    Map<int, String> bodies;

    Watcher(this.cfg, this.sched);

    Future start() async {
        await cfg.repos.forEach((Map repo) async {
            (await this.getIssues(repo)).forEach((i) {
                titles[i['id']] = i['title'];
                bodies[i['id']] = i['body'];
            });
        });
        sched.attach(new PeriodicHandler(this.pollHandler, cfg.pollFreq));
    }

    void pollHandler() {
        cfg.repos.forEach((Map repo) async {
            (await this.getIssues(repo)).forEach((i) {
                if(i['title'] != titles[i['id']] 
                || i['body']  != bodies[i['id']]) {
                    titles[i['id']] = i['title'];
                    bodies[i['id']] = i['body'];
                    
                }
            });
        });
    }

    Future<List> getIssues(Map repo) async {
        var url = Uri.parse('https://api.github.com/repos/${repo.name}/issues');
        var req = await new HttpClient().getUrl(url);
        req.headers.set('authorization', 'token ${repo.oAuth2}');
        var resp = await req.close();
        var json = resp.transform(UTF8.decoder).reduce((p,v) => p+v);
        return JSON.decode(json);
    }

}
