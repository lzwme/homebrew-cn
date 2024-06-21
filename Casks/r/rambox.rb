cask "rambox" do
  version "2.3.4"
  sha256 "e26b87e872af0007ae699293bc58d0b581692c9a36d89991756bf76da84737da"

  url "https:github.comramboxappdownloadreleasesdownloadv#{version}Rambox-#{version}-mac.zip",
      verified: "github.comramboxappdownload"
  name "Rambox"
  desc "Free and Open Source messaging and emailing app"
  homepage "https:rambox.app"

  auto_updates true

  app "Rambox.app"

  zap trash: [
    "~LibraryApplication SupportCrashReporterRambox Helper_*.plist",
    "~LibraryApplication SupportCrashReporterRambox_*.plist",
    "~LibraryApplication SupportRambox",
    "~LibraryCachescom.grupovrs.ramboxce",
    "~LibraryCachescom.grupovrs.ramboxce.ShipIt",
    "~LibraryCachescom.saenzramiro.rambox",
    "~LibraryLogsRambox",
    "~LibraryPreferencesByHostcom.grupovrs.ramboxce.ShipIt.*.plist",
    "~LibraryPreferencescom.grupovrs.ramboxce.helper.plist",
    "~LibraryPreferencescom.grupovrs.ramboxce.plist",
    "~LibraryPreferencescom.saenzramiro.rambox.helper.plist",
    "~LibraryPreferencescom.saenzramiro.rambox.plist",
    "~LibrarySaved Application Statecom.grupovrs.ramboxce.savedState",
    "~LibrarySaved Application Statecom.saenzramiro.rambox.savedState",
    "~LibraryWebKitcom.saenzramiro.rambox",
  ]
end