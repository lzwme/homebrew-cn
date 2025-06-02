cask "atlauncher" do
  version "3.4.40.0"
  sha256 "4d717baf2b94029d3f29eac0de8c869f79d40c96ac5c81f320f8c616a8a4c78a"

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