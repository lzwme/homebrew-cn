cask "gcs" do
  arch arm: "apple", intel: "intel"

  version "5.27.0"
  sha256 arm:   "c9bf888c19940861cda11e60232ba8f6857a0745ace49641d6eff9252976e98b",
         intel: "0d18ed9c061caa37798089688395704be760a04ef5d4c17c27bf4e8398256f7d"

  url "https:github.comrichardwilkesgcsreleasesdownloadv#{version}gcs-#{version}-macos-#{arch}.dmg",
      verified: "github.comrichardwilkesgcs"
  name "gcs"
  desc "Character sheet editor for the GURPS Fourth Edition roleplaying game"
  homepage "https:gurpscharactersheet.com"

  app "GCS.app"

  zap trash: [
    "~GCS",
    "~LibraryLogsgcs.log",
    "~LibraryPreferencescom.trollworks.gcs.plist",
    "~LibraryPreferencesgcs.json",
    "~LibrarySaved Application Statecom.trollworks.gcs.savedState",
  ]
end