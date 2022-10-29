#!/usr/bin/env bash

# for testing
# gst-launch-1.0 -v pulsesrc device="auto_null.monitor" ! audio/x-raw, channels=2, rate=24000 ! cutter ! opusenc ! webmmux ! filesink location=audio.mp3

tcpserver 0.0.0.0 ${AUDIO_SERVER:-1699} gst-launch-1.0 -q pulsesrc device="auto_null.monitor" ! audio/x-raw, channels=2, rate=24000 ! cutter ! opusenc ! webmmux ! fdsink fd=1
