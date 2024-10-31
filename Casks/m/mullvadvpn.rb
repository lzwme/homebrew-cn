cask "mullvadvpn" do
  version "2024.7"
  sha256 "86dc6a6602015c3639509f2315b346119704ea0e5df7d22600f9e24f5c276759"

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