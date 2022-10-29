#/bin/bash
set -e
# Wine version to install: stable or devel or staging
WINE_VERSION="stable"

dpkg --add-architecture i386
wget -qq -nc -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key

# Get Ubuntu version and trim to major only
OS_VER=$(lsb_release -r |cut -f2 |cut -d "." -f1)
# Choose repository based on Ubuntu version
SOURCE_LIST=""
if (( $OS_VER >= 22)); then
    SOURCE_LIST="winehq-jammy.sources"
elif (( $OS_VER < 22 )) && (( $OS_VER >= 21 )); then
    SOURCE_LIST="winehq-impish.sources"
elif (( $OS_VER < 21 )) && (( $OS_VER >=20 )); then
    SOURCE_LIST="winehq-focal.sources"
elif (( $OS_VER < 20 )); then
    SOURCE_LIST="winehq-bionic.sources"
fi

if [ -z "$SOURCE_LIST" ]
then
    exit 1
fi

wget -qq -nc -O "/etc/apt/sources.list.d/${SOURCE_LIST}" "https://dl.winehq.org/wine-builds/ubuntu/dists/$(lsb_release -cs)/${SOURCE_LIST}"

# install
apt-get -qqy update && apt-get install --install-recommends -qqy wine-$WINE_VERSION

# clean
rm "/etc/apt/sources.list.d/${SOURCE_LIST}"
bash /opt/scripts/apt_clean.sh
