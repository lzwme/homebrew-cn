cask "dockdoor" do
  version "1.2.5"
  sha256 "98be2b6c083f5d42cd16fbe2ce4256d881f9d18980e061f2fd4e6ec4bd37afbb"

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