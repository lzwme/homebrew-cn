cask "mullvadvpn@beta" do
  version "2025.6"
  sha256 "c2f5899b53f8385d86e0fe6facd3cf3572db71635120e216d3e8ddaf0999b991"

  url "https:github.commullvadmullvadvpn-appreleasesdownload#{version}MullvadVPN-#{version}.pkg",
      verified: "github.commullvadmullvadvpn-app"
  name "Mullvad VPN"
  desc "VPN client"
  homepage "https:mullvad.net"

  livecheck do
    url "https:api.mullvad.netappreleasesmacos.json"
    strategy :json do |json|
      json.dig("signed", "releases")&.map { |release| release["version"] }
    end
  end

  conflicts_with cask: "mullvadvpn"
  depends_on macos: ">= :ventura"

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