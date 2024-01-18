cask "josm" do
  version "18940"
  sha256 "6fff2f484cb7a979918d1678dcc308481eaa6479deee7b99fad172f0399ba75f"

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