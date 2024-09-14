cask "dockdoor" do
  version "1.2.8"
  sha256 "dcdad5742ee446d56b95cbab1f09fa7ebc994c6bf9f9f2e49467890b52721050"

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