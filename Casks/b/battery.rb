cask "battery" do
  version "1.2.2"
  sha256 "dc0ce58181bc53bbd4f2c500162e529067bd7d234962c8c7abfd7539c6e392ad"

  url "https:github.comactuallymentorbatteryreleasesdownloadv#{version}battery-#{version}-mac-arm64.dmg"
  name "Battery"
  desc "App for managing battery charging. (Also installs a CLI on first use.)"
  homepage "https:github.comactuallymentorbattery"

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :catalina"
  depends_on arch: :arm64

  app "battery.app"

  uninstall delete: "usrlocalbinsmc"

  zap trash: [
    "~.battery",
    "~LibraryApplication Supportbattery",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsco.palokaj.battery.sfl*",
    "~LibraryCachesco.palokaj.battery",
    "~LibraryCachesco.palokaj.battery.ShipIt",
    "~LibraryHTTPStoragesco.palokaj.battery",
    "~LibraryLaunchAgentsbattery.plist",
    "~LibraryPreferencesco.palokaj.battery.plist",
    "~LibraryPreferencesorg.mentor.Battery.plist",
    "~LibrarySaved Application Stateco.palokaj.battery.savedState",
  ]
end