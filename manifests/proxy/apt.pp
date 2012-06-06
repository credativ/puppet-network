class network::proxy::apt (
    $ensure,
    $proxies
    ){

    if $ensure {
        if $proxies["http_proxy"] {
            $http_proxy = $proxies["http_proxy"]
        }
        if $proxies["https_proxy"] {
            $https_proxy = $proxies["https_proxy"]
        }
        if $proxies["no_proxy"] {
            $no_proxy = split($proxies["no_proxy"], ",")
        }

        apt::conf { 'proxy':
            priority => '30',
            content => template('proxy-hiera/apt.conf.erb')
        }
    }
}
