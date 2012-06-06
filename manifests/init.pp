class network (
    $host_config_global = params_lookup('hostconfiguration', 'global'),
    $networks           = params_lookup('networks', 'global'),
    ) {

    # Get configuration for this host
    if ! $host_config_global[$::hostname] {
        fail("No host configuration defined for $::hostname.")
    } else {
        $host_config = $host_config_global[$::hostname]
    }

    # Generate udev rules
    $network_interfaces = $host_config['network_interfaces']
    file { '/etc/udev/rules.d/70-persistent-net.rules':
        ensure   => present,
        content  => template('network/udev_rules.erb'),
    }

    # Generate /etc/network/interfaces
    class { 'network::interfaces':
        interfaces  => $network_interfaces,
        networks    => $networks
    }
}
