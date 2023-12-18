cask "swifty" do
  version "0.6.13"
  sha256 "cc625c8c543bd8596694a5810e5db7967a6806b4511568cb6cda077bc02c3b4b"

  url "https:github.comswiftyappswiftyreleasesdownloadv#{version}Swifty-#{version}.dmg",
      verified: "github.comswiftyappswifty"
  name "Swifty"
  desc "Offline password manager tool"
  homepage "https:getswifty.pro"

  auto_updates true

  app "Swifty.app"

  zap trash: [
    "~LibraryApplication SupportSwifty",
    "~LibraryLogsSwifty",
    "~LibraryPreferencescom.electron.swifty.plist",
    "~LibrarySaved Application Statecom.electron.swifty.savedState",
  ]
end