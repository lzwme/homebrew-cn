cask "lunarbar" do
  version "1.3.0"
  sha256 "b4d1c1cb496d64e53c374aea9c802b827671cb14a90449eec706e2bdec81ec66"

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