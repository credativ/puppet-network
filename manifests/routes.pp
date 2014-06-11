class network::routes (
    $routes,
    ) {

    if $routes == undef {
     $ensure = 'absent'
    } else {
     $ensure = 'file'
    }

    file { "/etc/network/ip-routes":
     ensure  => $ensure,
     owner   => 'root',
     group   => 'root',
     mode    => '0644',
     content => $routes,
    }

    file { "/etc/network/if-up.d/ip-routes":
     ensure  => $ensure,
     owner   => 'root',
     group   => 'root',
     mode    => '0700',
     source  => "puppet:///modules/${module_name}/ip-routes",
   }
}
