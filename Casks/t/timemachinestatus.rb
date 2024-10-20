cask "timemachinestatus" do
  version "0.2.3"
  sha256 "50e444b58e8e9d92d12f9d74d08a705daf2ed2c23d7a23ac35e6b01446feb5b8"

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