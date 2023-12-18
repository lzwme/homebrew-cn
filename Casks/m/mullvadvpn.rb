cask "mullvadvpn" do
  version "2023.6"
  sha256 "5187ce19f9aa904685b29a7845f16b82a5664ac6877a926d5649518285f6afcf"

  url "https:github.commullvadmullvadvpn-appreleasesdownload#{version}MullvadVPN-#{version}.pkg",
      verified: "github.commullvadmullvadvpn-app"
  name "Mullvad VPN"
  desc "VPN client"
  homepage "https:mullvad.net"

  livecheck do
    url "https:mullvad.netdownloadapppkglatest"
    strategy :header_match
  end

  conflicts_with cask: "homebrewcask-versionsmullvadvpn-beta"
  depends_on macos: ">= :big_sur"

  pkg "MullvadVPN-#{version}.pkg"

  uninstall pkgutil:   "net.mullvad.vpn",
            launchctl: "net.mullvad.daemon",
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