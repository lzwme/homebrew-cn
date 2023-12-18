cask "battery" do
  version "1.2.0"
  sha256 "9601e755ce31e24e159d3c2cf53123fae5385916830e57b6746734b3d07163c0"

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