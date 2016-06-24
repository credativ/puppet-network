class network::proxy::apt (
    $manage,
    $proxies
    ){

    if $manage {
        if $proxies["http_proxy"] {
            $http_proxy = $proxies["http_proxy"]
        }
        if $proxies["https_proxy"] {
            $https_proxy = $proxies["https_proxy"]
        }
        if $proxies["no_proxy"] {
            $no_proxy = split($proxies["no_proxy"], ',')
        }

        apt::conf { 'proxy':
            priority => '30',
            content  => template('network/apt.conf.erb')
        }
    }
}
