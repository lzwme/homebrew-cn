cask "lunarbar" do
  version "1.2.0"
  sha256 "7af684d9479d5e0d7c8a45686b12808a5ce0680b828cc471a96c4112ff3c4fb3"

  url "https:github.comLunarBar-appLunarBarreleasesdownloadv#{version}LunarBar-#{version}.dmg"
  name "LunarBar"
  desc "Lunar calendar for menu bar"
  homepage "https:github.comLunarBar-appLunarBar"

  depends_on macos: ">= :ventura"

  app "LunarBar.app"

  zap trash: [
    "~LibraryApplication Scriptsapp.cyan.lunarbar",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsapp.cyan.lunarbar.sfl*",
    "~LibraryContainersapp.cyan.lunarbar",
    "~LibrarySaved Application Stateapp.cyan.lunarbar.savedState",
  ]
end