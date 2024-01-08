cask "heroic" do
  arch arm: "arm64", intel: "x64"

  version "2.12.0"
  sha256 arm:   "96f6293bf1a472fa6b9d1e8889dfca8130690b25e33da5450695aa3122bccd96",
         intel: "8a341acb51af9298e7c90710239d9d4361c6cbee25457fc6a6895c4cb8614703"

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