#!/bin/bash

set -ex

MT_URL=${MT_URL:-"https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5setup.exe"}

wget -qq -nc -O ~/mtsetup.exe $MT_URL

# Set environment to Windows 10
WINEPREFIX=~/.wine winecfg -v=win10
# Start MetaTrader installer
WINEPREFIX=~/.wine wine ~/mtsetup.exe
