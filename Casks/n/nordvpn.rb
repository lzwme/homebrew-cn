cask "nordvpn" do
  version "9.5.0"
  sha256 "7b4b4534b1b267c4f20a1b3d4bb6a79bcca3e14760bd362003e8ff3945656568"

  url "https://downloads.nordcdn.com/apps/macos/generic/NordVPN-OpenVPN/#{version}/NordVPN.pkg",
      verified: "downloads.nordcdn.com/apps/macos/generic/"
  name "NordVPN"
  desc "VPN client for secure internet access and private browsing"
  homepage "https://nordvpn.com/"

  livecheck do
    url "https://downloads.nordcdn.com/apps/macos/generic/NordVPN-OpenVPN/latest/update_pkg.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  pkg "NordVPN.pkg"

  uninstall launchctl:  [
              "com.nordvpn.macos.helper",
              "com.nordvpn.NordVPN.Helper",
            ],
            quit:       [
              "com.nordvpn.macos",
              "com.nordvpn.macos.NordVPNLauncher",
            ],
            login_item: "NordVPN",
            pkgutil:    "com.nordvpn.macos",
            delete:     [
              "/Library/PrivilegedHelperTools/com.nordvpn.macos.helper",
              "/Library/PrivilegedHelperTools/com.nordvpn.macos.ovpnDnsManager",
              "/Library/PrivilegedHelperTools/ovpn",
            ]

  zap trash: [
    "~/Library/Application Support/com.nordvpn.macos",
    "~/Library/Caches/com.nordvpn.macos",
    "~/Library/Containers/com.nordvpn.NordVPN.*",
    "~/Library/Cookies/com.nordvpn.macos.binarycookies",
    "~/Library/Logs/NordVPN",
    "~/Library/Preferences/com.nordvpn.macos.plist",
    "~/Library/Saved Application State/com.nordvpn.macos.savedState",
  ]
end