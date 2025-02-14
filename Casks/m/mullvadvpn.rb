cask "mullvadvpn" do
  version "2025.4"
  sha256 "af81d35022f6d1abecc0eacf33b3c767efbe16a0edb07beec5911c114092d69b"

  url "https:github.commullvadmullvadvpn-appreleasesdownload#{version}MullvadVPN-#{version}.pkg",
      verified: "github.commullvadmullvadvpn-app"
  name "Mullvad VPN"
  desc "VPN client"
  homepage "https:mullvad.net"

  livecheck do
    url "https:mullvad.netdownloadvpnmacos"
    regex(href=.*?MullvadVPN[._-]v?(\d+(?:\.\d+)+)\.pkgi)
  end

  conflicts_with cask: "mullvadvpn@beta"
  depends_on macos: ">= :ventura"

  pkg "MullvadVPN-#{version}.pkg"

  uninstall launchctl: "net.mullvad.daemon",
            pkgutil:   "net.mullvad.vpn",
            delete:    [
              "LibraryCachesmullvad-vpn",
              "LibraryLaunchDaemonsnet.mullvad.daemon.plist",
              "opthomebrewsharefishvendor_completions.dmullvad.fish",
              "usrlocalsharefishvendor_completions.dmullvad.fish",
              "usrlocalsharezshsite-functions_mullvad",
              "varlogmullvad-vpn",
            ]

  zap trash: [
    "etcmullvad-vpn",
    "~LibraryApplication SupportMullvad VPN",
    "~LibraryLogsMullvad VPN",
    "~LibraryPreferencesnet.mullvad.vpn.plist",
  ]
end