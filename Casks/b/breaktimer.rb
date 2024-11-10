cask "breaktimer" do
  version "1.3.0"
  sha256 "af57ccdbeb9687b4a28462bea9d18635edf128654bc2193336ee0093526453d1"

  url "https:github.comtom-james-watsonbreaktimer-appreleasesdownloadv#{version}BreakTimer.dmg",
      verified: "github.comtom-james-watsonbreaktimer-app"
  name "BreakTimer"
  desc "Tool to manage periodic breaks"
  homepage "https:breaktimer.app"

  auto_updates true

  app "BreakTimer.app"
  binary "#{appdir}BreakTimer.appContentsMacOSBreakTimer", target: "breaktimer"

  uninstall launchctl: "com.tomjwatson.breaktimer.ShipIt",
            quit:      "com.tomjwatson.breaktimer"

  zap trash: [
    "~LibraryApplication SupportBreakTimer",
    "~LibraryCachescom.tomjwatson.breaktimer",
    "~LibraryCachescom.tomjwatson.breaktimer.ShipIt",
    "~LibraryLogsBreakTimer",
    "~LibraryPreferencesByHostcom.tomjwatson.breaktimer.ShipIt.*.plist",
    "~LibraryPreferencescom.tomjwatson.breaktimer.plist",
    "~LibrarySaved Application Statecom.tomjwatson.breaktimer.savedState",
  ]
end