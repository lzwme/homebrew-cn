cask "gcs" do
  arch arm: "apple", intel: "intel"

  version "5.20.3"
  sha256 arm:   "6b09dddbe77c9d4ae000c8f7308e6702c2ad79201d590c1f69fc799cb72c516d",
         intel: "750ea62d6ae610dcf16b1f33b6fb77e92813c7ec9e79d9c183ae60a69c444f95"

  url "https:github.comrichardwilkesgcsreleasesdownloadv#{version}gcs-#{version}-macos-#{arch}.dmg",
      verified: "github.comrichardwilkesgcs"
  name "gcs"
  desc "Character sheet editor for the GURPS Fourth Edition roleplaying game"
  homepage "https:gurpscharactersheet.com"

  app "GCS.app"

  zap trash: [
    "~LibraryLogsgcs.log",
    "~LibraryPreferencescom.trollworks.gcs.plist",
    "~LibraryPreferencesgcs.json",
    "~LibrarySaved Application Statecom.trollworks.gcs.savedState",
    "~GCS",
  ]
end