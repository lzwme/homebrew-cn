cask "keka@beta" do
  version "1.5.2-dev.r5614"
  sha256 "9facc54fa1107630ff2678cfa7580fdc2a100fe0d870060b24c7626ff2b0994e"

  url "https:github.comaonezKekareleasesdownloadv#{version}Keka-#{version}.dmg",
      verified: "github.comaonezKeka"
  name "Keka"
  desc "File archiver"
  homepage "https:www.keka.io#beta"

  livecheck do
    url :url
    regex(^v?((?:\d+(?:\.\d+)+)([._-](?:beta|dev)(?:\.\w?\d+)?)?)i)
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