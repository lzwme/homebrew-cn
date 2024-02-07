cask "josm" do
  version "18969"
  sha256 "9e95d8ed624cd7ef7281e030d74d94b629a723fc97aace6f80f9dab66e0022b2"

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