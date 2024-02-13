cask "heroic" do
  arch arm: "arm64", intel: "x64"

  version "2.13.0"
  sha256 arm:   "82ed3d5b41d3745af1c5d2d1c6c154f12a5b8755fd2dce5c6250b7747d1f1b01",
         intel: "fae3109b0bcb6ba232e8489a2d370365588c6c1c64de7f90263fd799bfcbba4c"

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