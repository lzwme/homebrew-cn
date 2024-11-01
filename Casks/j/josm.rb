cask "josm" do
  version "19253"
  sha256 "6dc0a5fb0fa9bec47ef105ca8ccf5b5724c0833a7ec2b7bbd6d64ca79f952530"

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