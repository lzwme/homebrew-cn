cask "amneziavpn" do
  version "4.7.0.0"
  sha256 "8653b54b9eccb0778b2d23ee33f58ad026b1ef8312b559f02ae8fa3c66b4c288"

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

  caveats do
    requires_rosetta
  end
end