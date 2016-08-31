# docker-nexus

[![Docker Automated buil](https://img.shields.io/docker/automated/sathlan/docker-nexus.svg?maxAge=86400)]()
[![GitHub release](https://img.shields.io/github/release/sathlan/docker-nexus.svg?maxAge=86400)]()

A docker image based on
[sonatype](https://github.com/sonatype/docker-nexus3/blob/master/Dockerfile).
It deploy a working
[nexus foss](https://www.sonatype.com/download-oss-sonatype) server.

The main differences are:
 - it uses Fedora 24 instead of CentOS
 - it uses *systemd* to start, no pid 1 for java
   - the log goes to the host journal
 - it is tested against [serverspec](http://serverspec.org/)

## Install

```
$ docker run -v /sys/fs/cgroup:/sys/fs/cgroup:ro -t \
     -p 8081:8081 -d --name nexus sathlan/nexus
```

The start process takes time. Inspect it using `docker logs -f nexus`.

```
$ firefox localhost:8081
```

Login with `admin:admin123`.

The data lies in `/nexus-data`, so this is what the used volume
technology should mount.

## Install on a firewalld based server.

This should get you started.

```
$ sudo curl -o /etc/firewalld/services/nexus3.xml \
    https://raw.githubusercontent.com/sathlan/docker-nexus/master/firewalld-nexus.xml
$ sudo firewall-cmd --reload
$ firewall-cmd --get-services | grep nexus
$ firewall-cmd --zone=public --add-service=nexus
```

## Test

You need Fedora or CentOS, as the docker can run container running
systemd. Not sure about Debian based distribution.

```
$ bundle install
$ bundle exec rake spec
```

## License

MIT
