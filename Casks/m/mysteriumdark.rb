cask "mysteriumdark" do
  version "10.16.0"
  sha256 "f82135d0d86ac8f567783063a42fb87c1c98bfb76bb38e92d0929cd65b4fe4eb"

  url "https:github.commysteriumnetworkmysterium-vpn-desktopreleasesdownload#{version}MysteriumDark-#{version}-universal.dmg",
      verified: "github.commysteriumnetworkmysterium-vpn-desktop"
  name "Mysterium VPN"
  desc "VPN client"
  homepage "https:www.mysteriumvpn.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "MysteriumDark.app"

  zap trash: [
    "~.mysterium",
    "~LibraryApplication SupportMysteriumVPN",
    "~LibraryLogsMysteriumVPN",
    "~LibraryPreferencesnetwork.mysterium.mysterium-vpn-desktop.plist",
    "~LibrarySaved Application Statenetwork.mysterium.mysterium-vpn-desktop.savedState",
  ]
end