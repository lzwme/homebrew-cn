cask "josm" do
  version "19039"
  sha256 "57cf9452ee257f713e0d1e47e911e6e877b4306f4232f9ee629fa6794dfe014a"

  url "https:github.comJOSMjosmreleasesdownload#{version}-testedJOSM-macOS-java17-#{version}.zip",
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