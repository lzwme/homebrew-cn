cask "snapmaker-luban" do
  arch arm: "-arm64", intel: "-x64"

  version "4.12.0"
  sha256 arm:   "47c17a3be8a96886f1fbd02733d37ae2f8a626416b1bdd925e6c3f66e34d7593",
         intel: "f0163bc986567ddc2bde6b9bb75d3c10489939da5333a627ed5de299782fc355"

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