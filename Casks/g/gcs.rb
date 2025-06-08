cask "gcs" do
  arch arm: "arm64", intel: "amd64"

  version "5.36.1"
  sha256 arm:   "b8eb8a63a8fb8604880348805697fdcf24466c1052038748e63f4dc676a1f200",
         intel: "b45f22e9150040125119621bbf52fc35af20c29a1e500d7e61bc9d6a868eaa64"

  url "https:github.comrichardwilkesgcsreleasesdownloadv#{version}gcs-#{version}-macos-#{arch}.dmg",
      verified: "github.comrichardwilkesgcs"
  name "gcs"
  desc "Character sheet editor for the GURPS Fourth Edition roleplaying game"
  homepage "https:gurpscharactersheet.com"

  depends_on macos: ">= :mojave"

  app "GCS.app"

  zap trash: [
    "~GCS",
    "~LibraryLogsgcs.log",
    "~LibraryPreferencescom.trollworks.gcs.plist",
    "~LibraryPreferencesgcs.json",
    "~LibrarySaved Application Statecom.trollworks.gcs.savedState",
  ]
end