cask "battery" do
  version "1.2.1"
  sha256 "701884af16451ef956c9acb41e9bcb6d6eae07e6ca07840c67e56e0897b042d1"

  url "https:github.comactuallymentorbatteryreleasesdownloadv#{version}battery-#{version}-mac-arm64.dmg"
  name "Battery"
  desc "CLI for managing the battery charging status"
  homepage "https:github.comactuallymentorbattery"

  auto_updates true
  depends_on macos: ">= :high_sierra"
  depends_on arch: :arm64

  app "battery.app"

  uninstall delete: "usrlocalbinsmc"

  zap trash: [
    "~.battery",
    "~LibraryApplication Supportbattery",
    "~LibraryLaunchAgentsbattery.plist",
    "~LibraryPreferencesco.palokaj.battery.plist",
    "~LibraryPreferencesorg.mentor.Battery.plist",
    "~LibrarySaved Application Stateco.palokaj.battery.savedState",
  ]
end