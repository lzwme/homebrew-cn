cask "psychopy" do
  version "2024.2.1"
  sha256 "069a75e6c4a9fe849b347e2af8d743f609624bcb6941d40ac5b831ab87e0758b"

  url "https:github.compsychopypsychopyreleasesdownload#{version.major_minor_patch}StandalonePsychoPy-#{version}-macOS-py3.10.dmg"
  name "PsychoPy"
  desc "Create experiments in behavioral science"
  homepage "https:github.compsychopypsychopy"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "PsychoPy.app"

  zap trash: [
    "~.psychopy3",
    "~LibraryPreferencesorg.opensciencetools.psychopy.plist",
    "~LibrarySaved Application Stateorg.opensciencetools.psychopy.savedState",
  ]

  caveats do
    requires_rosetta
  end
end