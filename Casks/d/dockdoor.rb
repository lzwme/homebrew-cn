cask "dockdoor" do
  version "1.17"
  sha256 "fa1d0a1c92c672e6f81643fda81a829e15a9e7a33b608ea4f87be47dc0989209"

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