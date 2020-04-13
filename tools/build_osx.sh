#!/bin/bash
cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ../

rm -rf build
git pull

export APP_VER="$(cat client/package.json | grep version | cut -d '"' -f 4)"

# Service
cd service
go get -u -f
go build -v
cd ..
mkdir -p build/resources
cp service/service build/resources/fvpn-service
codesign --force --timestamp --options=runtime -s "Developer ID Application: FVPN, Inc. (U22BLATN63)" build/resources/fvpn-service

# Openvpn
cp openvpn_osx/openvpn build/resources/fvpn-openvpn
codesign --force --timestamp --options=runtime -s "Developer ID Application: FVPN, Inc. (U22BLATN63)" build/resources/fvpn-openvpn


# FVPN
mkdir -p build/osx/Applications
cd client
npm install
npm update
./node_modules/.bin/electron-rebuild
./node_modules/.bin/electron-packager ./ FVPN \
  --platform=darwin \
  --arch=x64 \
  --icon=./www/img/fvpn.icns \
  --darwinDarkModeSupport=true \
  --extra-resource="../build/resources/fvpn-service" \
  --extra-resource="../build/resources/fvpn-openvpn" \
  --osx-sign.hardenedRuntime \
  --osx-sign.hardened-runtime \
  --no-osx-sign.gatekeeper-assess \
  --osx-sign.entitlements="/Users/apple/go/src/github.com/JamesNguyen9x/test-ovpn/resources_osx/entitlements.plist" \
  --osx-sign.entitlements-inherit="/Users/apple/go/src/github.com/JamesNguyen9x/test-ovpn/resources_osx/entitlements.plist" \
  --osx-sign.entitlementsInherit="/Users/apple/go/src/github.com/JamesNguyen9x/test-ovpn/resources_osx/entitlements.plist" \
  --osx-sign.identity="Developer ID Application: FVPN, Inc. (U22BLATN63)" \
  --osx-notarize.appleId="contact@fvpn.com" \
  --osx-notarize.appleIdPassword="@keychain:xcode" \
  --out=../build/osx/Applications

cd ../
mv build/osx/Applications/FVPN-darwin-x64/FVPN.app build/osx/Applications/
rm -rf build/osx/Applications/FVPN-darwin-x64
sleep 3
#codesign --force --deep --timestamp --options=runtime --entitlements="./resources_osx/entitlements.plist" --sign "Developer ID Application: FVPN, Inc. (U22BLATN63)" build/osx/Applications/FVPN.app/Contents/MacOS/FVPN

# Files
mkdir -p build/osx/var/run
touch build/var/run/fvpn_auth
mkdir -p build/osx/var/log
touch build/osx/var/log/fvpn.log
touch build/osx/var/log/fvpn.log.1

# Service Daemon
mkdir -p build/osx/Library/LaunchDaemons
cp service_osx/com.fvpn.service.plist build/osx/Library/LaunchDaemons

# Client Agent
mkdir -p build/osx/Library/LaunchAgents
cp service_osx/com.fvpn.client.plist build/osx/Library/LaunchAgents

# Package
chmod +x resources_osx/scripts/postinstall
chmod +x resources_osx/scripts/preinstall
cd build
pkgbuild --root osx --scripts ../resources_osx/scripts --sign "Developer ID Installer: FVPN, Inc. (U22BLATN63)" --identifier com.fvpn.pkg.FVPN --version $APP_VER --ownership recommended --install-location / Build.pkg
productbuild --resources ../resources_osx --distribution ../resources_osx/distribution.xml --sign "Developer ID Installer: FVPN, Inc. (U22BLATN63)" --version $APP_VER FVPN.pkg
zip FVPN.pkg.zip FVPN.pkg
rm -f Build.pkg

# Notarize
xcrun altool --notarize-app --primary-bundle-id "com.fvpn.client.electron.pkg" --username "contact@fvpn.com" --password "@keychain:xcode" --asc-provider U22BLATN63 --file Pritunl.pkg
#sleep 3
#xcrun altool --notarize-app --primary-bundle-id "com.fvpn.client.electron.zip" --username "contact@fvpn.com" --password "@keychain:xcode" --asc-provider U22BLATN63 --file Pritunl.pkg.zip
sleep 10
xcrun altool --notarization-history 0 --username "contact@fvpn.com" --password "@keychain:xcode"
