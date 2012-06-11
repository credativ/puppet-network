class network::interfaces (
    $manage,
    $interfaces,
    $networks,
    ) {

    file { '/etc/network/interfaces':
        ensure => present,
        content => template('network/interfaces.erb')
    }
}
