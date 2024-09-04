cask "dockdoor" do
  version "1.2.0"
  sha256 "ebf18cb3631f6e67219ae934fee3388215a67098bf2b1582057a16b4cf064ace"

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