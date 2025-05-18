cask "atlauncher" do
  version "3.4.39.1"
  sha256 "0b2ed7540965d55ccc7b3c345fc61b1f3a8f0cf5ba1ad7ca27bc396eb1226100"

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