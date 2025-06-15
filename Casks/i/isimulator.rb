cask "isimulator" do
  version "3.3.0"
  sha256 "b9d4e1b3726ff3dd222f123a6d0b425015ff13733e95863a95d8256f80530a60"

  url "https:github.comwigliSimulatorreleasesdownload#{version}iSimulator.zip"
  name "iSimulator"
  desc "Utility to control and manage the Simulator"
  homepage "https:github.comwigliSimulator"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :catalina"

  app "iSimulator.app"

  zap delete: [
    "~LibraryApplication Supportniels.jin.iSimulator",
    "~LibraryCachesniels.jin.iSimulator",
    "~LibraryPreferencesniels.jin.iSimulator.plist",
  ]
end