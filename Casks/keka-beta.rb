cask "keka-beta" do
  version "1.4.0-dev.r5355"
  sha256 "24de36e624ee53a06a2f643a550b5bdca3a0f1e32dd71e633d2c6677bcd37673"

  url "https:github.comaonezKekareleasesdownloadv#{version}Keka-v#{version}.7z",
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