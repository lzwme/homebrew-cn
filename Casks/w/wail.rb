cask "wail" do
  version "0.2025.03.03"
  sha256 "db042c83e8617f9e288207fe12f10ccc8af31ac70e07d1d01953c0b95a5ca835"

  url "https:github.commachawk1wailreleasesdownloadv#{version}WAIL_v#{version}_macOS.dmg"
  name "WAIL"
  desc "Web Archiving Integration Layer: One-Click User Instigated Preservation"
  homepage "https:github.commachawk1wail"

  app "WAIL.app"

  zap trash: [
    "~LibraryApplication SupportWAIL",
    "~LibraryPreferencescom.matkelly.wail.plist",
    "~LibraryPreferencesWAIL_cli.plist",
    "~LibrarySaved Application Statecom.matkelly.wail.savedState",
  ]
end