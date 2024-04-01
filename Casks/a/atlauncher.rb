cask "atlauncher" do
  version "3.4.36.0"
  sha256 "e4bf29d45dcc00b652bc182a59b71f7af47edb698082b5983888559b27534e4b"

  url "https:github.comATLauncherATLauncherreleasesdownloadv#{version}ATLauncher-#{version}.zip",
      verified: "github.comATLauncherATLauncher"
  name "ATLauncher"
  desc "Minecraft launcher"
  homepage "https:atlauncher.com"

  app "ATLauncher.app"

  zap trash: [
    "~LibraryPreferencescom.atlauncher.App.plist",
    "~LibrarySaved Application Statecom.atlauncher.App.savedState",
  ]
end