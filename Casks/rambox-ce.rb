cask "rambox-ce" do
  version "0.8.0"
  sha256 "c5e93e259344a7b029869bbe7f9d222c141c0f0308fb0a82f6bd3d97f018ef1d"

  url "https:github.comramboxappcommunity-editionreleasesdownload#{version}Rambox-#{version}-mac-universal.zip",
      verified: "github.comramboxappcommunity-edition"
  name "Rambox Community Edition"
  desc "Free and Open Source messaging and emailing app"
  homepage "https:rambox.pro"

  deprecate! date: "2023-12-17", because: :discontinued

  conflicts_with cask: "rambox"

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