cask "snapmaker-luban" do
  arch arm: "-arm64", intel: "-x64"

  version "4.10.1"
  sha256 arm:   "4a401b17f5f67a5c16f567b32b880ebe4e3a9e2679396d48e5fbefaa08728c17",
         intel: "ee6dab1e393d65e950250ea53868a5cd6c786fad518eaf9e61d0fcf454dc4a56"

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