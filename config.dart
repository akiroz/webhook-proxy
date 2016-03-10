class Config {
    int get bindPort => 8000;
    Uri get targetUrl => new Uri.http('localhost:8001', '');
    List get repos => [
        'akiroz/test-repo',
    ];
}
