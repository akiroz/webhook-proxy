
import 'dart:io' show File;

class Config {

    /// Schduler quantum
    Duration get quantum => new Duration(seconds:10);
    
    /// github API polling frequency
    Duration get pollFreq {
        var numOfRepos = this.repos.length;
        var pollsPerHr = 5000/numOfRepos;
        var wait = (1/pollsPerHr)*60*60*1000;
        return new Duration(milliseconds:wait.toInt());
    }

    /// Webhook listening port
    int get bindPort => 8000;

    /// Target System URL
    Uri get targetUrl => new Uri.http('localhost:8001', '');

    /// List of repos to watch
    List<Map<String,String>> get repos => [
        {
            'name': 'akiroz/test-repo',
            'oAuth2': new File('akiroz.secret').readAsStringSync().trim()
        },
        {
            'name': 'akiroz/test-repo2',
            'oAuth2': new File('akiroz.secret').readAsStringSync().trim()
        },
    ];

}
