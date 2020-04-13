#!/bin/bash
set -e

codesign -s "Developer ID Application: FVPN, Inc. (U22BLATN63)" /usr/local/opt/openvpn/sbin/openvpn
