
import 'dart:async' show Future;
import 'dart:io' show HttpClient;
import 'dart:convert' show UTF8, JSON;

typedef Future Delegate(Map issue, Map gitRepo);
typedef Future Curried();

class Repo {
    // {name: '', oAuth2: ''}
    Map<String,String> repo;
    Map<int,String> titles;
    Map<int,String> bodies;
    Delegate sendWebHook;

    Repo(this.repo, this.sendWebHook) {
        titles = new Map();
        bodies = new Map();
    }

    Curried get init => ()=>_processIssues('init');
    Curried get poll => ()=>_processIssues('poll');

    // register issues & track changes
    // op: enum{'init', 'poll'}
    Future _processIssues(String op) async {
        try {
            var issues = await _gitGet('/repos/${repo['name']}/issues');
            for(var i in JSON.decode(issues)) {
                titles.putIfAbsent(i['id'], ()=> i['title']);
                bodies.putIfAbsent(i['id'], ()=> i['body']);
                if( op == 'poll'
                &&( titles[i['id']] != i['title']
                ||  bodies[i['id']] != i['body'] )) {
                    titles[i['id']] = i['title'];
                    bodies[i['id']] = i['body']; 
                    var gitRepo = await _gitGet('/repos/${repo['name']}');
                    sendWebHook(i, JSON.decode(gitRepo));
                }
            }
        } catch(e) {
            print(e);
        }
    }
    
    // GET github API
    dynamic _gitGet(String api) async {
        var url = Uri.parse('https://api.github.com'+api);
        var req = await new HttpClient().getUrl(url);
        req.headers.set('Authorization', 'token ${repo['oAuth2']}');
        req.headers.set('Accept', 'application/vnd.github.v3+json');
        var resp = await req.close();
        if(resp.statusCode >= 400) throw new Exception('GET $url returns ${resp.statusCode}');
        return resp.transform(UTF8.decoder).reduce((p,v) => p+v);
    }
}




