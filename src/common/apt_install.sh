#/bin/bash

apt-get -qqy update \
&& apt-get -qqy --no-install-recommends install "$@"
