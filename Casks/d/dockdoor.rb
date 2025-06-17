cask "dockdoor" do
  version "1.15.2"
  sha256 "43a8ec56fed1e1cc84c1b8c39c26d17657bdd269b70a7a99bd6ea36851cf7925"

  url "https:github.comejbillsDockDoorreleasesdownloadv#{version}DockDoor.dmg",
      verified: "github.comejbillsDockDoor"
  name "DockDoor"
  desc "Window peeking utility app"
  homepage "https:dockdoor.net"

  livecheck do
    url "https:dockdoor.netappcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "DockDoor.app"

  zap trash: [
    "~LibraryApplication SupportDockDoor",
    "~LibraryCachescom.ethanbills.DockDoor",
    "~LibraryHTTPStoragescom.ethanbills.DockDoor",
    "~LibraryPreferencescom.ethanbills.DockDoor.plist",
  ]
end