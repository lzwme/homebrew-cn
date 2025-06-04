cask "josm" do
  version "19412"
  sha256 "20d0a19a298f93c2b452e0c70c8879a6b8e3fe0c76e8fbf58353098611d577ef"

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