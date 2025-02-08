cask "mullvadvpn" do
  version "2025.3"
  sha256 "1bc741cabd02360a48b212cc7d9af2be2f4323c5a59989e34de490956d0441df"

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