cask "microsoft-teams-classic" do
  version "1.6.00.27656"
  sha256 "cd4cc25e0b4d24037e414226e201176e5be5d350d4d35be73fc531f11bc7ad2a"

  url "https://statics.teams.cdn.office.net/production-osx/#{version}/Teams_osx.pkg",
      verified: "statics.teams.cdn.office.net/production-osx/"
  name "Microsoft Teams Classic"
  desc "Meet, chat, call, and collaborate in just one place"
  homepage "https://www.microsoft.com/en-us/microsoft-teams/group-chat-software"

  # Microsoft releases multiple versions and builds of Teams, as listed here:
  #   https://ghproxy.com/https://raw.githubusercontent.com/ItzLevvie/MicrosoftTeams-msinternal/master/defconfig
  # and here:
  #   https://ghproxy.com/https://raw.githubusercontent.com/ItzLevvie/MicrosoftTeams-msinternal/master/defconfig2
  #
  # We only track the "production build"/"Public (R4) build" version,
  # which agrees with the version reported by `livecheck`.
  #
  # Any pull request that updates this Cask to a version that
  # differs from the `livecheck` version will be closed.
  livecheck do
    url "https://aka.ms/teamsmac"
    strategy :header_match
  end

  auto_updates true
  conflicts_with cask: "microsoft-office-businesspro"
  depends_on macos: ">= :el_capitan"

  pkg "Teams_osx.pkg"

  uninstall pkgutil:   [
              "com.microsoft.MSTeamsAudioDevice",
              "com.microsoft.teams",
            ],
            launchctl: "com.microsoft.teams.TeamsUpdaterDaemon",
            delete:    [
              "/Applications/Microsoft Teams classic.app",
              "/Library/Logs/Microsoft/Teams",
              "/Library/Preferences/com.microsoft.teams.plist",
            ]

  zap trash: [
        "~/Library/Application Support/com.microsoft.teams",
        "~/Library/Application Support/Microsoft/Teams",
        "~/Library/Application Support/Teams",
        "~/Library/Caches/com.microsoft.teams",
        "~/Library/Cookies/com.microsoft.teams.binarycookies",
        "~/Library/Logs/Microsoft Teams",
        "~/Library/Preferences/com.microsoft.teams.plist",
        "~/Library/Saved Application State/com.microsoft.teams.savedState",
        "~/Library/WebKit/com.microsoft.teams",
      ],
      rmdir: "~/Library/Application Support/Microsoft"
end