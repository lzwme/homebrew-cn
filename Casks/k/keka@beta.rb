cask "keka@beta" do
  version "1.4.8"
  sha256 "ae33510c32bdc77a2b63f0cd069a0c9ef063ee7a84d8b68abbcf1fe9511376a2"

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