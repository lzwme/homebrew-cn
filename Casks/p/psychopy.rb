cask "psychopy" do
  version "2024.1.5"
  sha256 "98cbcef6ea40fba188b31e461ccd4232810d1dfb486ea722118ce1b1095253b7"

  url "https:github.compsychopypsychopyreleasesdownload#{version.major_minor_patch}StandalonePsychoPy-#{version}-macOS.dmg"
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
end