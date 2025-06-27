cask "battery" do
  version "1.2.3"
  sha256 "e0a528db9d170a5b8d3e0feff01b12170b8a9fb5fd983054d505d864e081ba2d"

  url "https:github.comactuallymentorbatteryreleasesdownloadv#{version}battery-#{version}-mac-arm64.dmg"
  name "Battery"
  desc "App for managing battery charging. (Also installs a CLI on first use.)"
  homepage "https:github.comactuallymentorbattery"

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