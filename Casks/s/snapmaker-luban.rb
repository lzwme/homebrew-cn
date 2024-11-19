cask "snapmaker-luban" do
  arch arm: "-arm64", intel: "-x64"

  version "4.14.0"
  sha256 arm:   "b90ef54a77d45aca5f2be06885b61488c622af5abcdae7ada5ddd75d11d8bbdf",
         intel: "1938c3906e7090c3c06b1ce7f74337d37ec652b052ad5b4a57524bbd20844d0d"

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