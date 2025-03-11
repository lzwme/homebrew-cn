cask "heroic" do
  arch arm: "arm64", intel: "x64"

  version "2.16.1"
  sha256 arm:   "7918b0c530cbcfdd0028d45cfc2107f3bbb1b4ce50775663babd76599d467b74",
         intel: "8c5f89b8b40cdea4e4d572f6e7344c081ea0f31098d2b8a2be72161a45d82dc2"

  url "https:github.comHeroic-Games-LauncherHeroicGamesLauncherreleasesdownloadv#{version}Heroic-#{version}-macOS-#{arch}.dmg"
  name "Heroic Games Launcher"
  desc "Game launcher"
  homepage "https:github.comHeroic-Games-LauncherHeroicGamesLauncher"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Heroic.app"

  zap trash: [
    "~LibraryApplication Supportheroic",
    "~LibraryLogsheroic",
    "~LibraryPreferencescom.electron.heroic.plist",
    "~LibraryPreferencescom.heroicgameslauncher.hgl.plist",
    "~LibrarySaved Application Statecom.electron.heroic.savedState",
  ]
end