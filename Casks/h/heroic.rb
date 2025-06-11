cask "heroic" do
  arch arm: "arm64", intel: "x64"

  version "2.17.2"
  sha256 arm:   "bd5bbfd6d6a3252df3cd83384ecf2eacbb67ef8f5626b9ad294bda889e318e53",
         intel: "9e54cd13cad2ec106f6df64c9e25bc1e27d277bd4886fc70c57e49ab331a7cbb"

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