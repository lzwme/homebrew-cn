cask "mullvadvpn" do
  version "2024.4"
  sha256 "9b5c2efdf0aa8bad96ef8f2942345b774917e99a1d6a5f760da3907a8b8c5a09"

  url "https:github.commullvadmullvadvpn-appreleasesdownload#{version}MullvadVPN-#{version}.pkg",
      verified: "github.commullvadmullvadvpn-app"
  name "Mullvad VPN"
  desc "VPN client"
  homepage "https:mullvad.net"

  livecheck do
    url "https:mullvad.netdownloadapppkglatest"
    strategy :header_match
  end

  conflicts_with cask: "mullvadvpn@beta"
  depends_on macos: ">= :big_sur"

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