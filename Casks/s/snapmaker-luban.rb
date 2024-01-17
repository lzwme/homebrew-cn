cask "snapmaker-luban" do
  arch arm: "-arm64", intel: "-x64"

  version "4.10.2"
  sha256 arm:   "c8e21cde3bbb4b75412c4256dc257bb4f13d1f131c7dd98b8592100255e650a2",
         intel: "a82f50e12fd27b4f39154d8e12d52f141ccb4d04569a44c1495d7a09e28232b1"

  url "https:github.comsnapmakerlubanreleasesdownloadv#{version}Snapmaker-Luban-#{version}-mac#{arch}.dmg",
      verified: "github.comsnapmakerluban"
  name "Snapmaker Luban"
  desc "3D printing software"
  homepage "https:snapmaker.comsnapmaker-luban"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "Snapmaker Luban.app"

  zap trash: [
    "~LibraryCachescom.snapmaker.luban",
    "~LibraryCachescom.snapmaker.luban.ShipIt",
    "~LibraryPreferencesByHostcom.snapmaker.luban.ShipIt.*.plist",
    "~LibraryPreferencescom.snapmaker.luban.helper.plist",
    "~LibraryPreferencescom.snapmaker.luban.plist",
    "~LibrarySaved Application Statecom.snapmaker.luban.savedState",
  ]
end