cask "josm" do
  version "19230"
  sha256 "22b16d46535d5d923ab9c7d90bac846a7715e04e6510fefe54d85a67aa7db782"

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