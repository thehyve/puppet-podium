# Copyright 2017 The Hyve.
class podium::params(
    String[1] $user                                     = hiera('podium::user', 'podium'),
    Optional[String[2]] $user_home                      = hiera('podium::user_home', undef),

    String[1] $nexus_url                                = hiera('podium::nexus_url', 'https://repo.thehyve.nl'),
    Enum['snapshots', 'releases'] $registry_repository  = hiera('podium::registry_repository', 'releases'),
    Enum['snapshots', 'releases'] $podium_repository    = hiera('podium::podium_repository', 'releases'),

    String[1] $registry_version                         = hiera('podium::registry_version', '1.0.4'),
    String[1] $podium_version                           = hiera('podium::podium_version', '1.0.0'),

    String[8] $registry_password                        = hiera('podium::registry_password', undef),
    String[8] $jwt_secret                               = hiera('podium::jwt_secret', undef),
    Optional[String[1]] $registry_git_token             = hiera('podium::registry_git_token', undef),
    Optional[String[1]] $registry_git_ssh_key           = hiera('podium::registry_git_ssh_key', undef),
    Optional[String[1]] $registry_git_ssh_pubkey        = hiera('podium::registry_git_ssh_pubkey', undef),

    Optional[String[1]] $gateway_db_user                = hiera('podium::gateway_db_user', 'podiumGateway'),
    Optional[String[8]] $gateway_db_password            = hiera('podium::gateway_db_password', undef),
    String[1] $gateway_db_host                          = hiera('podium::gateway_db_host', 'localhost'),
    Integer $gateway_db_port                            = hiera('podium::gateway_db_port', 5432),
    String[1] $gateway_dbname                           = hiera('podium::gateway_dbname', 'podiumGateway'),
    Optional[String[1]] $uaa_db_user                    = hiera('podium::uaa_db_user', 'podiumUaa'),
    Optional[String[8]] $uaa_db_password                = hiera('podium::uaa_db_password', undef),
    String[1] $uaa_db_host                              = hiera('podium::uaa_db_host', 'localhost'),
    Integer $uaa_db_port                                = hiera('podium::uaa_db_port', 5432),
    String[1] $uaa_dbname                               = hiera('podium::uaa_dbname', 'podiumUaa'),

    String[1] $registry_memory                          = hiera('podium::registry_memory', '200m'),
    String[1] $gateway_memory                           = hiera('podium::gateway_memory', '2g'),
    String[1] $uaa_memory                               = hiera('podium::uaa_memory', '1g'),
    Integer $gateway_app_port                           = hiera('podium::gateway_app_port', 8080),
    Optional[String[1]] $app_url                        = hiera('podium::app_url', undef),

    String[1] $reply_address                            = hiera('podium::reply_address', 'podium@thehyve.nl'),
    Array[String[1]] $request_template_tokens           = hiera('podium::request_template_tokens', []),

    Boolean $disable_services                           = hiera('podium::disable_services', false),
) {

    if ($gateway_db_password == undef) {
        fail('No database password specified. Please configure podium::gateway_db_password')
    }
    if ($uaa_db_password == undef) {
        fail('No database password specified. Please configure podium::uaa_db_password')
    }
    if ($registry_password == undef) {
        fail('No registry password specified. Please configure podium::registry_password')
    }
    if ($jwt_secret == undef) {
        fail('No JWT secret specified. Please configure podium::jwt_secret')
    }

    $gateway_db_url = "jdbc:postgresql://${gateway_db_host}:${gateway_db_port}/${gateway_dbname}"
    $uaa_db_url = "jdbc:postgresql://${uaa_db_host}:${uaa_db_port}/${uaa_dbname}"

    # Set datashowcase user home directory
    if $user_home == undef {
        $podiumuser_home = "/home/${user}"
    } else {
        $podiumuser_home = $user_home
    }

    $registry_config_file = "${podiumuser_home}/registry-config.yml"
    $gateway_config_file = "${podiumuser_home}/gateway-config.yml"
    $uaa_config_file = "${podiumuser_home}/uaa-config.yml"

    $registry_war_file  = "${podiumuser_home}/podium-registry-${registry_version}.war"
    $gateway_war_file  = "${podiumuser_home}/podium-gateway-${podium_version}.war"
    $uaa_war_file  = "${podiumuser_home}/podium-uaa-${podium_version}.war"

}

