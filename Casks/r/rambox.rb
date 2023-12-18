cask "rambox" do
  version "2.2.3"
  sha256 "e0acd356746f77ddebbd17b0fe3bbd9078e292b4bdf138b916db544fdd497735"

  url "https:github.comramboxappdownloadreleasesdownloadv#{version}Rambox-#{version}-mac.zip",
      verified: "github.comramboxappdownload"
  name "Rambox"
  desc "Free and Open Source messaging and emailing app"
  homepage "https:rambox.pro"

  auto_updates true
  conflicts_with cask: "homebrewcask-versionsrambox-ce"

  app "Rambox.app"

  zap trash: [
    "~LibraryApplication SupportCrashReporterRambox Helper_*.plist",
    "~LibraryApplication SupportCrashReporterRambox_*.plist",
    "~LibraryApplication SupportRambox",
    "~LibraryCachescom.grupovrs.ramboxce.ShipIt",
    "~LibraryCachescom.grupovrs.ramboxce",
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