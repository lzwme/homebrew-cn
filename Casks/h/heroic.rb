cask "heroic" do
  arch arm: "arm64", intel: "x64"

  version "2.14.0"
  sha256 arm:   "3ad35338fb01e3b6aeff26c64b0a8bf30e5d0e62fa8fc3aac340d1755b851420",
         intel: "add48677166d908b50b108764022b772ff1261ac901ba92c1ca18f742b91c225"

  url "https:github.comHeroic-Games-LauncherHeroicGamesLauncherreleasesdownloadv#{version}Heroic-#{version}-macOS-#{arch}.dmg"
  name "Heroic Games Launcher"
  desc "Game launcher"
  homepage "https:github.comHeroic-Games-LauncherHeroicGamesLauncher"

  auto_updates true

  app "Heroic.app"

  zap trash: [
    "~LibraryApplication Supportheroic",
    "~LibraryLogsheroic",
    "~LibraryPreferencescom.electron.heroic.plist",
    "~LibrarySaved Application Statecom.electron.heroic.savedState",
  ]
end