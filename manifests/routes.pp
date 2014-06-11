class network::routes (
    $routes,
    ) {
    if $routes != undef {

         file { "/etc/network/ip-routes":
          ensure  => file,
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          content => $routes,
         }

         file { "/etc/network/if-up.d/ip-routes":
          ensure  => file,
          owner   => 'root',
          group   => 'root',
          mode    => '0700',
          source  => "puppet:///modules/${module_name}/ip-routes",
        }
    }
}
