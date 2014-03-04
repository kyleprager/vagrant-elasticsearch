# update apt-get to pull latest list of ubuntu packages
exec { "apt-update":

	command => "/usr/bin/sudo /usr/bin/apt-get update",

	unless => "/usr/bin/which java && /usr/bin/java -version 2>&1 | grep 1.7"

}

# install Open JDK 7 JRE
package { "openjdk-7-jre":
	
	ensure => installed,

	require => Exec["apt-update"]

}