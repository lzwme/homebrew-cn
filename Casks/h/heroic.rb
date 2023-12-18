cask "heroic" do
  arch arm: "arm64", intel: "x64"

  version "2.11.0"
  sha256 arm:   "45333a7e6bc60c8357bae87194630b4ee5fc9990ba84b27b2ca5e3cfaac28e6e",
         intel: "23a0adff2004afe8b3aa794cc46c15469dad42b7bfce5f5432f93c6cfc5672df"

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