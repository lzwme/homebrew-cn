cask "schism-tracker" do
  version "20240529"
  sha256 "a2ffce5b2135249cae701f4fd3d58ecae7b2c482349cc7e6940e6e2d0fc6f307"

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