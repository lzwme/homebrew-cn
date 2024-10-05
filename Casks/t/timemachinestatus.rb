cask "timemachinestatus" do
  version "0.2.1"
  sha256 "9c03daa27c3101598144a88b742c3ad6aa4eb68288e77befa3678224795aa8f6"

  url "https:github.comlukepistrolTimeMachineStatusreleasesdownload#{version}TimeMachineStatus.dmg"
  name "TimeMachineStatus"
  desc "Menu bar app to show Time Machine information"
  homepage "https:github.comlukepistrolTimeMachineStatus"

  livecheck do
    url "https:github.comlukepistrolTimeMachineStatusreleaseslatestdownloadappcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "TimeMachineStatus.app"

  uninstall launchctl: "com.lukepistrol.TimeMachineStatusHelper"

  zap trash: [
    "~LibraryApplication Scriptscom.lukepistrol.TimeMachineStatus*",
    "~LibraryPreferencescom.lukepistrol.TimeMachineStatus*.plist",
  ]
end