cask "cashnotify" do
  version "3.6.7"
  sha256 "3bb085ed582d5ecf65d0c94ab77f27ff11916ce6eb1d22e66dc20bc1c1b1b93c"

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