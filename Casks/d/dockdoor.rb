cask "dockdoor" do
  version "1.16"
  sha256 "b2c60cfcad3d77673651e72dbb7b5b630be9390d004238fe97729b14a333f126"

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