cask "mullvadvpn" do
  version "2025.2"
  sha256 "f5fdbe009489ef6c3f2d5182ca5b460dae555fbcbe3c132a9b7ff9316e41be0f"

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