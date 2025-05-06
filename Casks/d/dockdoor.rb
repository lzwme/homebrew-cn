cask "dockdoor" do
  version "1.8"
  sha256 "8f7a00c6d6fa4d4388acbafb4479e2edc72c0b8e426d55b44398fa5f5e307f2d"

  url "https:github.comejbillsDockDoorreleasesdownloadv#{version}DockDoor.dmg",
      verified: "github.comejbillsDockDoor"
  name "DockDoor"
  desc "Window peeking utility app"
  homepage "https:dockdoor.net"

  livecheck do
    url "https:dockdoor.netappcast.xml"
    strategy :sparkle
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