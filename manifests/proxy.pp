class network::proxy (
    $manage = false,
    $proxies,
    ) {

    if $manage {
        class { 'network::proxy::apt':
            manage  => $manage,
            proxies => $proxies
        }

        class { 'network::proxy::environment':
            manage  => $manage,
            proxies => $proxies,
        }
    }
}
