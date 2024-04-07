cask "heroic" do
  arch arm: "arm64", intel: "x64"

  version "2.14.1"
  sha256 arm:   "7059218695c96394a2102398437d270ecec08e9a0e21e1ac8a36ead266e67eff",
         intel: "65d2a288b02a616b65b66efb0996e914c56003bbfd937b389741d7d59843b5e1"

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