
import 'dart:async' show Future;
import 'dart:convert' show UTF8, JSON;
import 'dart:io' show HttpClient, ContentType;

import 'package:webhook_proxy/config.dart' show Config;
import 'package:webhook_proxy/scheduler.dart' show Scheduler, PeriodicHandler;
import 'package:webhook_proxy/repo.dart' show Repo;

class Watcher {
    Config cfg;
    Scheduler sched;
    List<Repo> repos;

    Watcher(this.cfg, this.sched) {
        this.repos = new List.from(cfg.repos.map((r) => new Repo(r, sendWebHook)));
    }

    void start() {
        repos.forEach((r) => r.init());
        sched.attach(new PeriodicHandler(() {
            repos.forEach((r) => r.poll());
        }, cfg.pollFreq));
    }

    Future sendWebHook(Map gitIssue, Map gitRepo) async {
        Map webhook = {
            'action': 'updated',
            'issue': gitIssue,
            'repository': gitRepo,
            'sender': gitIssue['user']
        };
        List<int> payload = UTF8.encode(JSON.encode(webhook));
        var req = await new HttpClient().postUrl(cfg.targetUrl);
        req.headers.set('user-agent', 'Webhook-Proxy');
        req.headers.set('accept', '*/*');
        req.headers.set('X-GitHub-Event', 'issues');
        req.headers.contentType = new ContentType('application', 'json');
        req.headers.contentLength = payload.length;
        req.add(payload);
        req.close();
    }

}
