#!/bin/bash
set -e

read -r -p "Install FVPN Client? [y/N] " response
if ! [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    exit
fi

APP_VER="1.0.1436.36"

curl -L https://github.com/JamesNguyen9x/test-ovpn/archive/$APP_VER.tar.gz | tar x
cd fvpn-client-electron-$APP_VER

# FVPN
mkdir -p build/osx/Applications
cd client
npm install
./node_modules/.bin/electron-rebuild
./node_modules/.bin/electron-packager ./ FVPN --platform=darwin --arch=x64 --icon=./www/img/fvpn.icns --out=../build/osx/Applications
cd ../
mv build/osx/Applications/FVPN-darwin-x64/FVPN.app build/osx/Applications/
rm -rf build/osx/Applications/FVPN-darwin-x64

# Service
cd service
GOPATH="$(pwd)/go" go get -d
GOPATH="$(pwd)/go" go build -v
cd ..
cp service/service build/osx/Applications/FVPN.app/Contents/Resources/fvpn-service

# Service Daemon
mkdir -p build/osx/Library/LaunchDaemons
cp service_osx/com.fvpn.service.plist build/osx/Library/LaunchDaemons

# Client Agent
mkdir -p build/osx/Library/LaunchAgents
cp service_osx/com.fvpn.client.plist build/osx/Library/LaunchAgents

# Openvpn
cp openvpn_osx/openvpn build/osx/Applications/FVPN.app/Contents/Resources/fvpn-openvpn

# Files
touch /var/run/fvpn_auth
touch /var/log/fvpn.log
touch /var/log/fvpn.log.1

# Preinstall
echo "###################################################"
echo "Preinstall: Stopping fvpn service..."
echo "###################################################"
kill -2 $(ps aux | grep FVPN.app | awk '{print $2}') &> /dev/null || true
sudo launchctl unload /Library/LaunchAgents/com.fvpn.client.plist &> /dev/null || true
sudo launchctl unload /Library/LaunchDaemons/com.fvpn.service.plist &> /dev/null || true

# Install
echo "###################################################"
echo "Installing..."
echo "###################################################"
sudo rm -rf /Applications/FVPN.app
sudo cp -r build/osx/Applications/FVPN.app /Applications
sudo cp -f build/osx/Library/LaunchAgents/com.fvpn.client.plist /Library/LaunchAgents/com.fvpn.client.plist
sudo cp -f build/osx/Library/LaunchDaemons/com.fvpn.service.plist /Library/LaunchDaemons/com.fvpn.service.plist

# Postinstall
echo "###################################################"
echo "Postinstall: Starting fvpn service..."
echo "###################################################"
sudo launchctl load /Library/LaunchDaemons/com.fvpn.service.plist

cd ..
rm -rf fvpn-client-electron-$APP_VER
