cask "schism-tracker" do
  version "20231029"
  sha256 "ef989be5936013eb47327b465f93c2a94616b3173d10ce14aa8b4247a5964f27"

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