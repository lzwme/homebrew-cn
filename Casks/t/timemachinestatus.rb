cask "timemachinestatus" do
  version "0.1.0"
  sha256 "8c363dc018b125ecc8e41756b99555e518ad75ddbd11553106a1f284d4c83b85"

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