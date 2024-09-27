cask "mullvadvpn@beta" do
  version "2024.6-beta1"
  sha256 "abb8471306bcb1a4471aab11c7db2926f434f40272defd632600e81fac93a03b"

  url "https:github.commullvadmullvadvpn-appreleasesdownload#{version}MullvadVPN-#{version}.pkg",
      verified: "github.commullvadmullvadvpn-app"
  name "Mullvad VPN"
  desc "VPN client"
  homepage "https:mullvad.net"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+[._-]beta\d*)$i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  conflicts_with cask: "mullvadvpn"

  pkg "MullvadVPN-#{version}.pkg"

  uninstall launchctl: "net.mullvad.daemon",
            quit:      "net.mullvad.vpn",
            pkgutil:   "net.mullvad.vpn"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsnet.mullvad.vpn.sfl*",
    "~LibraryApplication SupportMullvad VPN",
    "~LibraryLogsMullvad VPN",
    "~LibraryPreferencesnet.mullvad.vpn.helper.plist",
    "~LibraryPreferencesnet.mullvad.vpn.plist",
  ]
end