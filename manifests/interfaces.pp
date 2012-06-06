class network::interfaces (
    $interfaces,
    $networks,
    ) {

    file { '/tmp/etc/network/interfaces':
        ensure => present,
        template => ('interfaces.erb')
    }
}
