cask "adguard-vpn" do
  version "2.3.1.593"
  sha256 "83995e3ae3b6031747cc546b27c2356d8930507df646aabefa16ee9dd7d72bba"

  url "https://static.adguard-vpn.com/mac/release/AdGuardVPN-#{version}.dmg"
  name "AdGuard VPN"
  desc "VPN for privacy and security"
  homepage "https://adguard-vpn.com/"

  livecheck do
    url "https://static.adguard-vpn.com/mac/adguard-release-appcast.xml"
    strategy :sparkle do |item|
      item.short_version.delete_suffix(" release")
    end
  end

  auto_updates true
  conflicts_with cask: "adguard-vpn-nightly"
  depends_on macos: ">= :catalina"

  pkg "AdGuard VPN.pkg"

  uninstall launchctl: [
              "com.adguard.mac.vpn.tun-helper",
              "com.adguard.mac.vpn.vpn_helper",
            ],
            quit:      "com.adguard.mac.vpn",
            pkgutil:   "com.adguard.mac.vpn-pkg",
            delete:    [
              "/Library/Application Support/AdGuard Software/com.adguard.mac.vpn",
              "/Library/Application Support/com.adguard.mac.vpn",
              "/Library/Logs/com.adguard.mac.vpn",
            ],
            rmdir:     "/Library/Application Support/AdGuard Software"

  zap trash: [
    "~/Library/Application Scripts/*com.adguard.mac*",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.adguard.mac.vpn.launchatlogin.sfl*",
    "~/Library/Caches/com.adguard.mac.vpn",
    "~/Library/Containers/com.adguard.mac.vpn.launchatlogin",
    "~/Library/Group Containers/*.com.adguard.mac",
    "~/Library/HTTPStorages/com.adguard.mac.vpn",
    "~/Library/Preferences/com.adguard.mac.vpn.plist",
  ]
end