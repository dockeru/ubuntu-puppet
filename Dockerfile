FROM 		ubuntu:16.04
MAINTAINER	technopreneural@yahoo.com

		# Install updates
RUN		apt-get update \
		&& DEBIAN_FRONTEND=noninteractive apt-get install -y \
			curl \

		# Install puppetlabs apt repository
		&& curl -O http://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb \
		&& dpkg -i puppetlabs-release-pc1-trusty.deb \
		&& rm puppetlabs-release-pc1-trusty.deb \

		# Install puppetserver
		&& apt-get update \
		&& DEBIAN_FRONTEND=noninteractive apt-get install -y \
			puppetserver \

		# Reduce memory allocation to 512MB from 4GB default
		&& sed -i '/JAVA_ARGS=/s/\(-Xm[sx]\)2g/\1512m/g' /etc/default/puppetserver \

		# Cleanup
		&& rm -rf /var/lib/apt/lists/*

		# Create volume to access puppet code from host
VOLUME		["/etc/puppetlabs/code/"]

EXPOSE		443 8140 8142 61613

ENTRYPOINT	["/opt/puppetlabs/bin/puppetserver", "foreground"]

ENV		PATH $PATH:/opt/puppetlabs/bin
