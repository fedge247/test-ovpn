# Stop FVPN
kill -2 $(ps aux | grep FVPN.app | awk '{print $2}') &> /dev/null || true
sudo launchctl unload /Library/LaunchAgents/com.fvpn.client.plist &> /dev/null || true
sudo launchctl unload /Library/LaunchDaemons/com.fvpn.service.plist &> /dev/null || true

# FVPN
sudo rm -rf /Applications/FVPN.app
sudo rm -f /Library/LaunchAgents/com.fvpn.client.plist
sudo rm -f /Library/LaunchDaemons/com.fvpn.service.plist
sudo rm -f /private/var/db/receipts/com.fvpn.pkg.FVPN.bom
sudo rm -f /private/var/db/receipts/com.fvpn.pkg.FVPN.plist

# Profile Files
rm -rf ~/Library/Application Support/fvpn
rm -rf ~/Library/Caches/fvpn
rm -rf ~/Library/Preferences/com.electron.fvpn.plist

# Old Files
sudo rm -rf /var/lib/fvpn
sudo rm -f /var/log/fvpn.log
sudo kextunload -b net.sf.tuntaposx.tap &> /dev/null || true
sudo kextunload -b net.sf.tuntaposx.tun &> /dev/null || true
sudo rm -rf /Library/Extensions/tap.kext
sudo rm -rf /Library/Extensions/tun.kext
sudo rm -f /Library/LaunchDaemons/net.sf.tuntaposx.tap.plist
sudo rm -f /Library/LaunchDaemons/net.sf.tuntaposx.tun.plist
sudo rm -rf /usr/local/bin/fvpn-openvpn
sudo rm -rf /usr/local/bin/fvpn-service

echo "###################################################"
echo "Uninstallation Successful"
echo "###################################################"
