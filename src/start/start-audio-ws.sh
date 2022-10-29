#!/usr/bin/env bash

websockify localhost:${AUDIO_WS:-7900} localhost:${AUDIO_SERVER:-1699}
