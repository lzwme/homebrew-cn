cask "schism-tracker" do
  version "20240609"
  sha256 "91a2bb98db789324415393086184f0869e3f2baf9a23c41cc8c1eb88c217b90a"

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