cask "dockdoor" do
  version "1.14.4"
  sha256 "3cb0eb72600d4d7e9e31a82d9f855844dbb85639700ac60642a536af559cc8e5"

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