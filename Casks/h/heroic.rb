cask "heroic" do
  arch arm: "arm64", intel: "x64"

  version "2.17.1"
  sha256 arm:   "0e64b8f138534c7e0ff165197e26dd3bfac7004118dd6963e18f22e67969ea8e",
         intel: "4ba3e887a679d4bca4e7e61d66a64d233c5db0931b3df8069135b126070e39f4"

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