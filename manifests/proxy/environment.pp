class proxy-hiera::environment($proxies) {
    $env_changes = split(inline_template("
<% proxies.each do |key, val| -%>
set <%= key %> <%= val %>
<%end -%>
"), "\n")

    augeas { 'set_environment_proxy':
        context => '/files/etc/environment',
        changes => $env_changes
    }
}

