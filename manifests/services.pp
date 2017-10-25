# Copyright 2017 The Hyve.
class podium::services inherits podium::params {

    require ::podium::user
    require ::podium::database
    require ::podium::artefacts
    require ::podium::config

    $user = $podium::params::user
    $home = $podium::params::podiumuser_home

    $registry_version = $podium::params::registry_version
    $podium_version = $podium::params::podium_version

    $nexus_url = $podium::params::nexus_url
    $registry_repository = $podium::params::registry_repository
    $podium_repository = $podium::params::podium_repository

    $registry_war_file  = $podium::params::registry_war_file
    $gateway_war_file  = $podium::params::gateway_war_file
    $uaa_war_file  = $podium::params::uaa_war_file

    $default_java_opts = '-server -Djava.awt.headless=true'
    $default_app_opts = '-Dspring.profiles.active=prod -Djava.security.egd=file:///dev/urandom'

    $registry_memory = $::podium::params::registry_memory
    $registry_java_opts = "${default_java_opts} -Xms${registry_memory} -Xmx${registry_memory}"
    $registry_branch_opts = '-Dspring.cloud.config.label=dev'
    $registry_app_opts = "${default_app_opts} ${registry_branch_opts}"
    $registry_start_script = "${home}/start_registry"

    $gateway_memory = $::podium::params::gateway_memory
    $gateway_java_opts = "${default_java_opts} -Xms${gateway_memory} -Xmx${gateway_memory}"
    $gateway_app_port = $::podium::params::gateway_app_port
    $gateway_config_opts = "-Dspring.config.location=${::podium::params::gateway_config_file}"
    $gateway_app_opts = "${default_app_opts} -Dserver.port=${gateway_app_port} ${gateway_config_opts}"
    $gateway_start_script = "${home}/start_gateway"

    $uaa_memory = $::podium::params::uaa_memory
    $uaa_java_opts = "${default_java_opts} -Xms${uaa_memory} -Xmx${uaa_memory} "
    $uaa_config_opts = "-Dspring.config.location=${::podium::params::uaa_config_file}"
    $uaa_app_opts = "${default_app_opts} ${uaa_config_opts}"
    $uaa_start_script = "${home}/start_uaa"

    Service {
        #ensure   => running,
        provider => 'systemd',
    }

    file { $registry_start_script:
        ensure  => file,
        owner   => $user,
        mode    => '0744',
        content => template('podium/service/start_registry.erb'),
        notify  => Service['podium-registry'],
    }
    -> file { '/etc/systemd/system/podium-registry.service':
        ensure  => file,
        mode    => '0644',
        content => template('podium/service/podium-registry.service.erb'),
        notify  => Service['podium-registry'],
    }
    # Start the podium-registry service
    -> service { 'podium-registry':
        require  => [
            Archive::Nexus[$registry_war_file],
        ],
    }

    file { $gateway_start_script:
        ensure  => file,
        owner   => $user,
        mode    => '0744',
        content => template('podium/service/start_gateway.erb'),
        notify  => Service['podium-gateway'],
    }
    -> file { '/etc/systemd/system/podium-gateway.service':
        ensure  => file,
        mode    => '0644',
        content => template('podium/service/podium-gateway.service.erb'),
        notify  => Service['podium-gateway'],
    }
    # Start the podium-gateway service
    -> service { 'podium-gateway':
        require  => [
            Archive::Nexus[$gateway_war_file],
            Postgresql::Server::Database[$::podium::params::gateway_dbname]
        ],
    }

    file { $uaa_start_script:
        ensure  => file,
        owner   => $user,
        mode    => '0744',
        content => template('podium/service/start_uaa.erb'),
        notify  => Service['podium-uaa'],
    }
    -> file { '/etc/systemd/system/podium-uaa.service':
        ensure  => file,
        mode    => '0644',
        content => template('podium/service/podium-uaa.service.erb'),
        notify  => Service['podium-uaa'],
    }
    # Start the podium-uaa service
    -> service { 'podium-uaa':
        require  => [
            Archive::Nexus[$uaa_war_file],
            Postgresql::Server::Database[$::podium::params::uaa_dbname]
        ],
    }
}

