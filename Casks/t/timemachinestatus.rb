cask "timemachinestatus" do
  version "0.1.4"
  sha256 "5e8e36c3d9fff446e23d19dc03eedec365563ff1a9dcfb2d8155e4dd948dfdc1"

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