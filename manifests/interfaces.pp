class network::interfaces (
    $interfaces,
    $networks,
    ) {

    file { '/etc/network/interfaces':
        ensure => present,
        template => ('network/interfaces.erb')
    }
}
