class network (
    $host_config_global = params_lookup('hostconfiguration', 'global'),
    $manage_interfaces  = params_lookup('manage_interfaces', 'global'),
    $networks           = params_lookup('networks', 'global'),
    $use_proxy          = params_lookup('use_proxy', 'global'),
    $proxies            = params_lookup('proxies', 'global'),
    $ip_routes          = params_lookup('routes'),
    $use_resolvconf     = params_lookup('use_resolvconf', 'global'),
    $ensure_ifenslave   = params_lookup('ensure_ifenslave'),
    ) inherits network::params {

    $manage_interfaces_real = any2bool($manage_interfaces)

    if $manage_interfaces_real {
        # Get configuration for this host
        if ! $host_config_global[$::hostname] {
            fail("No host configuration defined for ${::hostname}.")
        } else {
            $host_config = $host_config_global[$::hostname]
        }

        # Generate udev rules
        $network_interfaces = $host_config['network_interfaces']
        file { '/etc/udev/rules.d/70-persistent-net.rules':
            ensure  => present,
            content => template('network/udev_rules.erb'),
        }

        # Generate /etc/network/interfaces
        class { 'network::interfaces':
            manage     => $manage_interfaces,
            interfaces => $network_interfaces,
            networks   => $networks
        }
    }

    class { 'network::routes':
        routes => $ip_routes,
    }

    class { 'network::proxy':
        manage  => $use_proxy,
        proxies => $proxies
    }

    $ensure_resolvconf = $use_resolvconf ? {
      true    => present,
      false   => absent,
      default => absent,
    }

    if $ensure_ifenslave != 'ignore' {
        package { 'ifenslave-2.6':
            ensure => $ensure_ifenslave,
        }
    }

    package { 'resolvconf':
        ensure => $ensure_resolvconf,
    }
}
