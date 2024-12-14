cask "mysteriumdark" do
  version "10.17.10"
  sha256 "268aa1d0695aa4d6c65341c99902e0aeae85aadd8539f30aadb71e7c78057143"

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