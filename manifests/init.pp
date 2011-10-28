class tor {
  package { [ "tor", "polipo", "torsocks" ]:
    ensure => installed,
  }

  service { "tor":
    ensure  => running,
    require => Package['tor'],
  }

  service { "polipo":
    ensure  => running,
  }

  file { "/etc/polipo/config":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    source  => "puppet:///modules/tor/polipo.conf",
    require => Package["polipo"],
    notify  => Service["polipo"],
    before  => Service["tor"],
  }

  # TODO: restore file to original state after the following bug is solved:
  # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=580434
  file { "/etc/cron.daily/polipo":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0755,
    require => Package["polipo"],
    source  => "puppet:///modules/tor/polipo.cron",
  }
}
