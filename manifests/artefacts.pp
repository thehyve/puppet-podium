# Copyright 2017 The Hyve.
class podium::artefacts inherits podium::params {
    require ::podium
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

    Archive::Nexus {
        owner   => $user,
        group   => $user,
    }

    # Download the registry war
    archive::nexus { $registry_war_file:
        user       => $user,
        url        => $nexus_url,
        gav        => "nl.thehyve.podium:podium-registry:${registry_version}",
        repository => $registry_repository,
        packaging  => 'war',
        mode       => '0444',
        creates    => $registry_war_file,
        require    => File[$home],
        notify     => Service['podium-registry'],
        cleanup    => false,
    }

    # Download the Gateway war
    archive::nexus { $gateway_war_file:
        user       => $user,
        url        => $nexus_url,
        gav        => "nl.thehyve.podium:podium-gateway:${podium_version}",
        repository => $podium_repository,
        packaging  => 'war',
        mode       => '0444',
        creates    => $gateway_war_file,
        require    => File[$home],
        notify     => Service['podium-gateway'],
        cleanup    => false,
    }

    # Download the UAA war
    archive::nexus { $uaa_war_file:
        user       => $user,
        url        => $nexus_url,
        gav        => "nl.thehyve.podium:podium-uaa:${podium_version}",
        repository => $podium_repository,
        packaging  => 'war',
        mode       => '0444',
        creates    => $uaa_war_file,
        require    => File[$home],
        notify     => Service['podium-uaa'],
        cleanup    => false,
    }

}

