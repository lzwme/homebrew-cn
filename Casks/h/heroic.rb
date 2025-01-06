cask "heroic" do
  arch arm: "arm64", intel: "x64"

  version "2.15.2"
  sha256 arm:   "8c35963a36c4990a4da955a7596ca4d2f03c81f024de5a1f91cc7151e4e424b6",
         intel: "370e7af3600bb04dae3d4a413365ffdd9a5dda87283438b443e257fd0475bace"

  url "https:github.comHeroic-Games-LauncherHeroicGamesLauncherreleasesdownloadv#{version}Heroic-#{version}-macOS-#{arch}.dmg"
  name "Heroic Games Launcher"
  desc "Game launcher"
  homepage "https:github.comHeroic-Games-LauncherHeroicGamesLauncher"

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