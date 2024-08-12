cask "heroic" do
  arch arm: "arm64", intel: "x64"

  version "2.15.1"
  sha256 arm:   "87cb560a0943808c3beea1c1c580267e1c6e46b4994d23b2f46cf30b7c1c4a04",
         intel: "36d0065ba1d9912540aa4cda99537c86577be77fe2113c910e44402dea99d21b"

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