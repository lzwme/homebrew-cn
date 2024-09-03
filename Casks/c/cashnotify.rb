cask "cashnotify" do
  version "3.7.0"
  sha256 "98977df0f1b9776b890285c353bebf1f03eed1cf3d15cb6d85412f5bee30db87"

  url "https:github.comBaguetteEngineeringdownload.cashnotify.comreleasesdownloadv#{version}CashNotify-#{version}.dmg",
      verified: "github.comBaguetteEngineeringdownload.cashnotify.com"
  name "CashNotify"
  desc "Monitor your Stripe and Paypal accounts from your menubar"
  homepage "https:cashnotify.com"

  auto_updates true

  app "CashNotify.app"

  uninstall launchctl: "com.baguetteengineering.cashnotify.ShipIt",
            quit:      "com.baguetteengineering.cashnotify"

  zap trash: [
    "~LibraryApplication SupportCachescashnotify-updater",
    "~LibraryApplication SupportCashNotify",
    "~LibraryCachescom.baguetteengineering.cashnotify",
    "~LibraryCachescom.baguetteengineering.cashnotify.ShipIt",
    "~LibraryLogsCashNotify",
    "~LibraryPreferencescom.baguetteengineering.cashnotify.helper.plist",
    "~LibraryPreferencescom.baguetteengineering.cashnotify.plist",
    "~LibrarySaved Application Statecom.baguetteengineering.cashnotify.savedState",
  ]

  caveats do
    requires_rosetta
  end
end