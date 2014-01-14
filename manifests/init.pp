class jdk{
  package { 'java-1.7.0-openjdk':
        ensure => 'installed',
        provider => 'yum'
  }
}

class neo4j {
  require jdk

  # GLOBAL PATH SETTING
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

  # configurable stuff here
  $neo_download_root = "http://dist.neo4j.org"
  $neo_edition = "community"
  $neo_version = "2.0.0"
  $neo_install_path = "/opt"

  $neo_filename = "neo4j-${neo_edition}-${neo_version}-unix.tar.gz"
  $neo_package_url = "${neo_download_root}/${neo_filename}"

  #file {'neo install directory':
  #      ensure =>         directory,
  #      path =>         "${neo_install_path}",
  #}
  #->
  exec { 'download neo4j package':
        command => "wget ${neo_package_url} -O /tmp/neo4j.tar.gz",
        creates => "/tmp/neo4j.tar.gz"
  }
  ->
  exec{ 'unzip neo':
        command => "tar -xzvf /tmp/neo4j.tar.gz",
        cwd => "${neo_install_path}"
  }
  ->
  exec{ 'rename neo':
        command => "mv ${neo_install_path}/*neo4j* ${neo_install_path}/neo4j",
        cwd => "${neo_install_path}"
  }

  package{ 'lsof':
    ensure => 'installed'
  }
}
