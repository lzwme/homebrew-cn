cask "breaktimer" do
  version "1.3.2"
  sha256 "d6e46421ec302431132040cbdd148e3ba634b609c42a152ad85c27f00ea440b0"

  url "https:github.comtom-james-watsonbreaktimer-appreleasesdownloadv#{version}BreakTimer.dmg",
      verified: "github.comtom-james-watsonbreaktimer-app"
  name "BreakTimer"
  desc "Tool to manage periodic breaks"
  homepage "https:breaktimer.app"

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :big_sur"

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