cask "schism-tracker" do
  version "20240308"
  sha256 "ce4aaf6dbe9760c5b7f198e366eb2a96bb00a285689d9d21ace0e8769bda6c82"

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