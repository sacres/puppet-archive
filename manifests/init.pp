class archive inherits archive::params {
  package { 'faraday':
    ensure   => present,
    provider => $archive::params::gem_provider,
  }

  package { 'faraday_middleware':
    ensure   => present,
    provider => $archive::params::gem_provider,
  }
}
