cask "keka@beta" do
  version "1.4.0-dev.r5423"
  sha256 "f25f579c532fd5e528aa4d61db8625988da75d032195cf5381cdc9c4f9122a7e"

  url "https:github.comaonezKekareleasesdownloadv#{version}Keka-#{version}.dmg",
      verified: "github.comaonezKeka"
  name "Keka"
  desc "File archiver"
  homepage "https:www.keka.io#beta"

  livecheck do
    url :url
    regex(^v?((?:\d+(?:\.\d+)+)-(?:beta|dev)(?:\.\w?\d+)?)?i)
  end

  auto_updates true
  conflicts_with cask: "keka"

  app "Keka.app"

  zap trash: [
    "~LibraryApplication SupportKeka",
    "~LibraryCachescom.aone.keka",
    "~LibraryPreferencescom.aone.keka.plist",
    "~LibrarySaved Application Statecom.aone.keka.savedState",
  ]
end