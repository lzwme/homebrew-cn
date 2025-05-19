cask "atlauncher" do
  version "3.4.39.3"
  sha256 "afa2be387baadad23fdd597cda65796c7ec9c75050faec4325bfcd45617a1303"

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