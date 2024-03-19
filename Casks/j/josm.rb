cask "josm" do
  version "19017"
  sha256 "418bc00be5bb8070b9ba7c1f71b434b33e54d5590cc082149035902bdbc37b60"

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