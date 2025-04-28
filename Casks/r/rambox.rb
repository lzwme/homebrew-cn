cask "rambox" do
  version "2.4.1"
  sha256 "b54c7a650e94eb80961bf1b1f476a12e0519f037a3181f73a6a7c4227751ff90"

  url "https:github.comramboxappdownloadreleasesdownloadv#{version}Rambox-#{version}-mac.zip",
      verified: "github.comramboxappdownload"
  name "Rambox"
  desc "Workspace simplifier - to organize your workspace and boost your productivity"
  homepage "https:rambox.app"

  auto_updates true
  depends_on macos: ">= :catalina"

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