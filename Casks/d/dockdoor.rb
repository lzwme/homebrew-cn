cask "dockdoor" do
  version "1.5"
  sha256 "07d270ebc86952f9b183a00a6c84c4f89ed6f5387a3f3ad4721cb643bf817bd2"

  url "https:github.comejbillsDockDoorreleasesdownloadv#{version}DockDoor.dmg"
  name "DockDoor"
  desc "Window peeking utility app"
  homepage "https:github.comejbillsDockDoor"

  auto_updates true
  depends_on macos: ">= :ventura"

  app "DockDoor.app"

  zap trash: [
    "~LibraryApplication SupportDockDoor",
    "~LibraryPreferencescom.ethanbills.DockDoor.plist",
  ]
end