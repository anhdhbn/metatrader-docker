#/bin/bash

apt-get autoclean \
&& apt-get autoremove \
&& rm -rf /var/lib/apt/lists/* /var/cache/apt/*
