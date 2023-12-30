cask "gcs" do
  arch arm: "apple", intel: "intel"

  version "5.19.0"
  sha256 arm:   "4d72f5a1855ba22eaf8601b9565c3a71d16bc844aa484296acb1e40b742d9d1a",
         intel: "7e2340b0ad72d96a6014b9880fa5bcf8de8f4dc0e056e1d05a832a8c225e48b3"

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