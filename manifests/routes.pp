# class to manage static routes via if-up hook
class network::routes (
    $routes,
    ) {

    if empty($routes) {
     $ensure = 'absent'
    } else {
     $ensure = 'file'
    }

    file { '/etc/network/ip-routes':
     ensure  => $ensure,
     owner   => 'root',
     group   => 'root',
     mode    => '0644',
     content => template('network/ip-routes.erb'),
    }

    file { '/etc/network/if-up.d/ip-routes':
     ensure => $ensure,
     owner  => 'root',
     group  => 'root',
     mode   => '0700',
     source => "puppet:///modules/${module_name}/ip-routes",
   }
}
