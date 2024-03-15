cask "lunarbar" do
  version "1.2.1"
  sha256 "47af325b18fb3350cc9092432583cc3be72677ef41828b9ffbced5d0a4f4b897"

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