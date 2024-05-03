cask "amneziavpn" do
  version "4.5.3.0"
  sha256 "847f8e09bb5d58ee5e1c84a66dad9db19b89607161a16cd1598c0ce37046f9c3"

  url "https:github.comamnezia-vpnamnezia-clientreleasesdownload#{version}AmneziaVPN_#{version}.dmg",
      verified: "github.comamnezia-vpnamnezia-client"
  name "Amnezia VPN"
  desc "VPN client"
  homepage "https:amnezia.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "AmneziaVPN.app"

  uninstall quit:   [
              "AmneziaVPN",
              "AmneziaVPN-service",
            ],
            delete: "ApplicationsAmneziaVPN.app"

  zap trash: [
    "~LibraryCachesAmneziaVPN.ORG",
    "~LibraryPreferencesAmneziaVPN.plist",
    "~LibraryPreferencesorg.amneziavpn.AmneziaVPN.plist",
  ]
end