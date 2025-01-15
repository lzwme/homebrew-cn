cask "snapmaker-luban" do
  arch arm: "-arm64", intel: "-x64"

  version "4.15.0"
  sha256 arm:   "19dfeb650f2b4eae56b1226ab99c36f79c61185895fcf56b9430c1d56f06cc3f",
         intel: "edbce70cd71b0007ff270a7f14b7d2cd09269eccf9200e83905536910a19c4e6"

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