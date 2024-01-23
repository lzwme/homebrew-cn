cask "betterdiscord-installer" do
  version "1.3.0"
  sha256 "85bdd7b44f9624f7740af4d26682f21730c47a643fde009f2ad766afa19356b8"

  url "https:github.comBetterDiscordInstallerreleasesdownloadv#{version}BetterDiscord-Mac.zip",
      verified: "github.comBetterDiscordInstaller"
  name "BetterDiscord"
  desc "Installer for BetterDiscord"
  homepage "https:betterdiscord.app"

  depends_on cask: "discord"

  app "BetterDiscord.app"

  zap trash: [
    "~LibraryApplication SupportBetterDiscord Installer",
    "~LibraryApplication SupportBetterDiscord",
    "~LibraryPreferencesapp.betterdiscord.installer.plist",
    "~LibrarySaved Application Stateapp.betterdiscord.installer.savedState",
  ]
end