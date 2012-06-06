class network::interfaces (
    $manage,
    $interfaces,
    $networks,
    ) {

    file { '/etc/network/interfaces':
        ensure => present,
        template => ('network/interfaces.erb')
    }
}
