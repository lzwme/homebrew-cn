cask "timemachinestatus" do
  version "0.2.2"
  sha256 "7131c4792dfa2b5f774b4283d2c36cd0a8694c4bcaf8f628fde1f819f1e757a0"

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