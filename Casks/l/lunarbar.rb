cask "lunarbar" do
  version "1.4.3"
  sha256 "7f2ab19b68fac51c842d468f43ddaaadaebcd9ff37d6f66568afdbf69e8b1210"

  url "https:github.comLunarBar-appLunarBarreleasesdownloadv#{version}LunarBar-#{version}.dmg"
  name "LunarBar"
  desc "Lunar calendar for menu bar"
  homepage "https:github.comLunarBar-appLunarBar"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sonoma"

  app "LunarBar.app"

  zap trash: [
    "~LibraryApplication Scriptsapp.cyan.lunarbar",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsapp.cyan.lunarbar.sfl*",
    "~LibraryContainersapp.cyan.lunarbar",
    "~LibrarySaved Application Stateapp.cyan.lunarbar.savedState",
  ]
end