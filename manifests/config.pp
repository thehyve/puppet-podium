# Copyright 2017 The Hyve.
class podium::config inherits podium::params {
    require ::podium::user

    $gateway_db_url = $podium::params::gateway_db_url
    $gateway_db_user = $podium::params::gateway_db_user
    $gateway_db_password = $podium::params::gateway_db_password
    $uaa_db_url = $podium::params::uaa_db_url
    $uaa_db_user = $podium::params::uaa_db_user
    $uaa_db_password = $podium::params::uaa_db_password
    $app_url = $podium::params::app_url
    $reply_address = $podium::params::reply_address
    $registry_password = $podium::params::registry_password
    $jwt_secret = $podium::params::jwt_secret
    $user = $podium::params::user
    $home = $podium::params::podiumuser_home
    $gateway_config_file = $podium::params::gateway_config_file
    $uaa_config_file = $podium::params::uaa_config_file
    $registry_config_file = $podium::params::registry_config_file
    $request_template_tokens = $podium::params::request_template_tokens

    File {
        ensure  => present,
        owner   => $user,
        group   => $user,
        mode    => '0600',
    }

    file { "${home}/.ssh":
        ensure => directory,
        mode   => '0700',
        owner  => $user,
    }
    # Fetch the host key for github.com
    -> exec { 'Fetch github.com host key':
        command => 'ssh-keyscan -H -t rsa github.com > .ssh/known_hosts',
        path    => ['/bin', '/usr/bin', '/usr/local/bin'],
        creates => "${home}/.ssh/known_hosts",
        cwd     => $home,
        user    => $user,
    }

    file { $gateway_config_file:
        content => template('podium/config/gateway-config.yml.erb'),
    }
    file { $uaa_config_file:
        content => template('podium/config/uaa-config.yml.erb'),
    }
    file { $registry_config_file:
        content => template('podium/config/registry-config.yml.erb'),
    }

}

