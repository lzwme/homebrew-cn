cask "psychopy" do
  version "2024.1.3"
  sha256 "3e801766ca90e1ec352ea1642be9bbad14cba3cd7d151fe35e4af57f096840e4"

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