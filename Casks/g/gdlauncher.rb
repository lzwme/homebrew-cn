cask "gdlauncher" do
  version "1.1.30"
  sha256 "d98a89f76047cef4ca7bdd99fe464f09fbe95c3ae916123ae4179dd8368514b9"

  url "https:github.comgorilla-devsGDLauncherreleasesdownloadv#{version}GDLauncher-mac-setup.dmg",
      verified: "github.comgorilla-devsGDLauncher"
  name "GDLauncher"
  desc "Custom Minecraft Launcher"
  homepage "https:gdevs.io"

  app "GDLauncher.app"

  zap trash: [
    "~LibraryApplication Supportgdlauncher",
    "~LibraryApplication Supportgdlauncher_next",
    "~LibraryLogsgdlauncher",
    "~LibraryPreferencesorg.gorilladevs.GDLauncher.plist",
    "~LibrarySaved Application Stateorg.gorilladevs.GDLauncher.savedState",
  ]
end