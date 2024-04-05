cask "psychopy" do
  version "2024.1.1"
  sha256 "1c08aa13bfaa84811c4cc142504edccc9709dc1713896922adc95feb3e1b4d33"

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