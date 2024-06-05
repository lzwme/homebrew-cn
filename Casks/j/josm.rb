cask "josm" do
  version "19096"
  sha256 "a8e3121b678068c1c2bc95d8cc6d3b3606fa7d1f4c6c5408e7ed71bb119b0555"

  url "https:github.comJOSMjosmreleasesdownload#{version}-testedJOSM-macOS-java21-#{version}.zip",
      verified: "github.comJOSMjosm"
  name "JOSM"
  desc "Extensible editor for OpenStreetMap"
  homepage "https:josm.openstreetmap.de"

  livecheck do
    url :url
    regex(\D*?(\d+(?:\.\d+)*)i)
    strategy :github_latest
  end

  app "JOSM.app"

  zap trash: [
    "~LibraryCachesJOSM",
    "~LibraryJOSM",
    "~LibraryPreferencesJOSM",
    "~LibrarySaved Application Statede.openstreetmap.josm.savedState",
  ]
end