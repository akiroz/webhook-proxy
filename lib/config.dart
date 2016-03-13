
import 'dart:io' show File;

class Config {

    /// Schduler polling quantum
    Duration get quantum => new Duration(seconds:10);

    /// Webhook listening port
    int get bindPort => 8000;

    /// Target System URL
    Uri get targetUrl => new Uri.http('localhost:8001', '');

    /// List of repos to watch
    List<Map<String,String>> get repos => [
        {
            'name': 'akiroz/test-repo',
            'oAuth2': new File('../akiroz.secret').readAsStringSync()
        },
        {
            'name': 'akiroz/test-repo2',
            'oAuth2': new File('../akiroz.secret').readAsStringSync()
        }
    ];

}
