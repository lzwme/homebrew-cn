cask "heroic" do
  arch arm: "arm64", intel: "x64"

  version "2.12.1"
  sha256 arm:   "69f9e76c0183535ef791b9474cfb1b08d0e066ebe7be49468eef7b92cb7d068c",
         intel: "d10214f8fe8d8414667784df87a62ccd43712ad7b83647c9cccf3049deec11cd"

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