cask "hamsket-nightly" do
  version "0.6.5"
  sha256 "58d967060ff0a25dc35df3d22d58ef4c63142af9014b8fcb4aad3d7b906862ff"

  url "https:github.comTheGoddessInarihamsketreleasesdownloadnightlyHamsket-#{version}.dmg"
  name "Hamsket"
  desc "Free and Open Source messaging and emailing app"
  homepage "https:github.comTheGoddessInarihamsket"

  deprecate! date: "2024-01-01", because: :discontinued

  depends_on macos: ">= :high_sierra"

  app "Hamsket.app"

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
    "~LibraryApplication SupportHamsket",
    "~LibrarySaved Application Statecom.thegoddessinari.hamsket.savedState",
  ]
end