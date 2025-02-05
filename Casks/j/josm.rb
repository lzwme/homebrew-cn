cask "josm" do
  version "19307"
  sha256 "c052d05c639a4671436440e56709aff306f7a4d25b571a1c6158dcf30cb5435d"

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