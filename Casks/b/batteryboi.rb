cask "batteryboi" do
  version "2.4.1,27"
  sha256 "9406640e508ead5e66c28a3121d1b96e22576acf49aba849c11fdb5ba019ba23"

  url "https:github.comthebarbican19BatteryBoireleasesdownloadVersion#{version.csv.first}%23#{version.csv.second}BatteryBoi-V#{version.csv.first}.dmg",
      verified: "github.comthebarbican19BatteryBoi"
  name "BatteryBoi"
  desc "Battery indicator for the menu bar"
  homepage "https:batteryboi.ovatar.io"

  livecheck do
    url "https:api.ovatar.ioversion?id=com.ovatar.batteryapp"
    strategy :sparkle
  end

  depends_on macos: ">= :big_sur"

  app "BatteryBoi.app"

  zap trash: [
    "~LibraryApplication SupportBatteryBoi",
    "~LibraryCachescom.ovatar.batteryapp",
    "~LibraryHTTPStoragescom.ovatar.batteryapp",
    "~LibraryPreferencescom.ovatar.batteryapp.plist",
    "~LibrarySaved Application Statecom.ovatar.batteryapp.savedState",
  ]
end