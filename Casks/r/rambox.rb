cask "rambox" do
  version "2.3.1"
  sha256 "e7933baeee1632f0101686a6d2813b3b70cbd18f460e417089e7ed8b831605c9"

  url "https:github.comramboxappdownloadreleasesdownloadv#{version}Rambox-#{version}-mac.zip",
      verified: "github.comramboxappdownload"
  name "Rambox"
  desc "Free and Open Source messaging and emailing app"
  homepage "https:rambox.app"

  auto_updates true
  conflicts_with cask: "rambox-ce"

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