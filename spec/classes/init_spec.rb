require 'spec_helper'

# Proxies to use in test
$proxies = {
  'http'  => 'http://ourproxy:8181',
  'https' => 'https://sslproxy:443',
}

# No proxy setting to use in test
# module expects a string currently ..
$no_proxy = ['localrepository.foo.lan','localpuppet.foo.lan']
$no_proxy_string = $no_proxy.join("")

# Routes for test of ip-routes files
$routes = [
  '172.4.4.0/24 via 192.168.1.1',
  '172.16.4.0/24 via 192.168.1.1',
]

describe 'network' do
  let(:facts) { {
    :hostname => 'debian7-node1',
    :osfamily => 'Debian',
    :operatingsystem => 'Debian',
    :operatingsystemrelease => 'wheezy',
    :concat_basedir => '/tmpvi',
    :lsbdistid => 'Debian'
  } }


    it { is_expected.to compile.with_all_deps }

  context 'with proxies' do
    let (:params) {{
      :use_proxy  => true,
      :proxies    => {
        'http_proxy'  => $proxies['http'],
        'https_proxy' => $proxies['https'],
        'no_proxy'    => $no_proxy_string
      }
    }}

    it { is_expected.to contain_apt__conf('proxy') }
    it do
      is_expected.to contain_apt__conf('proxy')
        .with_content(/Acquire::https::Proxy.*#{$proxies['https']}/)
    end
    it do
      is_expected.to contain_apt__conf('proxy')
        .with_content(/Acquire::http::Proxy.*#{$proxies['http']}/)
    end

    $no_proxy.each do |proxy|
      it do
        is_expected.to contain_apt__conf('proxy')
          .with_content(/Acquire::https::Proxy.*#{proxy}.*DIRECT/)
        is_expected.to contain_apt__conf('proxy')
          .with_content(/Acquire::https::Proxy.*#{proxy}.*DIRECT/)
      end
    end
  end

  context 'with routes' do
    let (:params) {{
      :ip_routes => $routes
    }}

    it { is_expected.to contain_file('/etc/network/if-up.d/ip-routes')}
    it do
      is_expected.to contain_file('/etc/network/if-up.d/ip-routes')
        .with({
          :ensure => 'file',
          :mode   => '0700'

        })
    end

    $routes.each do |route|
      it do
        is_expected.to contain_file('/etc/network/ip-routes')
          .with_content(/^#{route}$/)
      end
    end


  end
end
