cask "gcs" do
  arch arm: "apple", intel: "intel"

  version "5.33.0"
  sha256 arm:   "cd425f50ffe6405b50f631da1b333c00ee05d5d34e99360154b27d8f50c93226",
         intel: "67725eadafcb290680b6015f974670f96a171bbabfc2e25e5c01f9b54e10c76d"

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