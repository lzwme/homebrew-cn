cask "dockdoor" do
  version "1.1.5"
  sha256 "d1c07e74a554bd2b4379457069ead45a33a91cda5667f17cd7a64efd4fad211e"

  url "https:github.comejbillsDockDoorreleasesdownloadv#{version}DockDoor.dmg"
  name "DockDoor"
  desc "Window peeking utility app"
  homepage "https:github.comejbillsDockDoor"

  depends_on macos: ">= :sonoma"

  app "DockDoor.app"

  zap trash: [
    "~LibraryApplication SupportDockDoor",
    "~LibraryPreferencescom.ethanbills.DockDoor.plist",
  ]
end