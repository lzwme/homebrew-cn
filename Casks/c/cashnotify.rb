cask "cashnotify" do
  version "3.6.4"
  sha256 "f195b73ad787a0afef91728b7d516f5a5c6a3c9d05c2b37642e407c2346d893d"

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
end