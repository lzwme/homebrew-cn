cask "mullvadvpn" do
  version "2024.2"
  sha256 "8486851d964ada89ba26a5142868daa1eb36343d6ccdfc26e467b0f75586b4f2"

  url "https:github.commullvadmullvadvpn-appreleasesdownload#{version}MullvadVPN-#{version}.pkg",
      verified: "github.commullvadmullvadvpn-app"
  name "Mullvad VPN"
  desc "VPN client"
  homepage "https:mullvad.net"

  livecheck do
    url "https:mullvad.netdownloadapppkglatest"
    strategy :header_match
  end

  conflicts_with cask: "mullvadvpn-beta"
  depends_on macos: ">= :big_sur"

  pkg "MullvadVPN-#{version}.pkg"

  uninstall launchctl: "net.mullvad.daemon",
            pkgutil:   "net.mullvad.vpn",
            delete:    [
              "LibraryCachesmullvad-vpn",
              "LibraryLaunchDaemonsnet.mullvad.daemon.plist",
              "varlogmullvad-vpn",
            ]

  zap trash: [
    "etcmullvad-vpn",
    "~LibraryApplication SupportMullvad VPN",
    "~LibraryLogsMullvad VPN",
    "~LibraryPreferencesnet.mullvad.vpn.plist",
  ]
end