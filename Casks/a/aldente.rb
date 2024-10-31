cask "aldente" do
  version "1.28.6"
  sha256 "839d971f1d632b454480b4092febd7d7a6c577c78cbb4770f05aa9e213ad56d1"

  url "https:github.comAppHouseKitchenAlDente-Charge-Limiterreleasesdownload#{version}AlDente.dmg",
      verified: "github.comAppHouseKitchenAlDente-Charge-Limiter"
  name "AlDente"
  desc "Menu bar tool to limit maximum charging percentage"
  homepage "https:apphousekitchen.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "AlDente.app"

  uninstall launchctl:  "com.apphousekitchen.aldente-pro.helper",
            quit:       "com.apphousekitchen.aldente-pro",
            login_item: "AlDente",
            delete:     "LibraryPrivilegedHelperToolscom.apphousekitchen.aldente-pro.helper"

  zap trash: [
    "~LibraryApplication SupportAlDente",
    "~LibraryCachescom.apphousekitchen.aldente-pro",
    "~LibraryHTTPStoragescom.apphousekitchen.aldente-pro",
    "~LibraryHTTPStoragescom.apphousekitchen.aldente-pro.binarycookies",
    "~LibraryPreferencescom.apphousekitchen.aldente-pro.plist",
    "~LibraryPreferencescom.apphousekitchen.aldente-pro_backup.plist",
    "~LibraryPreferencescom.apphousekitchen.aldente-pro_stats.sqlite3",
  ]
end