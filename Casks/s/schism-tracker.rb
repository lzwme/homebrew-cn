cask "schism-tracker" do
  version "20240129"
  sha256 "f8e0badb25d055eeb92f3bf2ed983c8ef766adb573f6119bdc1b804ecdbbc635"

  url "https:github.comschismtrackerschismtrackerreleasesdownload#{version}schismtracker-#{version}-macos.zip"
  name "Schism Tracker"
  desc "Oldschool sample-based music composition tool"
  homepage "https:github.comschismtrackerschismtracker"

  app "Schism Tracker.app"

  zap trash: [
    "~LibraryApplication SupportSchism Tracker",
    "~LibrarySaved Application Stateorg.schismtracker.SchismTracker.savedState",
  ]
end