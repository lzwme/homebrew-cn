cask "lunarbar" do
  version "1.2.3"
  sha256 "ae58ce682e7656509ca25d154726e8188ef0a36d09108c24a78251f94078b575"

  url "https:github.comLunarBar-appLunarBarreleasesdownloadv#{version}LunarBar-#{version}.dmg"
  name "LunarBar"
  desc "Lunar calendar for menu bar"
  homepage "https:github.comLunarBar-appLunarBar"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :ventura"

  app "LunarBar.app"

  zap trash: [
    "~LibraryApplication Scriptsapp.cyan.lunarbar",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsapp.cyan.lunarbar.sfl*",
    "~LibraryContainersapp.cyan.lunarbar",
    "~LibrarySaved Application Stateapp.cyan.lunarbar.savedState",
  ]
end