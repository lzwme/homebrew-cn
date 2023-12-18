cask "josm" do
  version "18907"
  sha256 "b4424a06cb7e9faebd24435445df62a45cd5ef24bf2595846247e5abc7788364"

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