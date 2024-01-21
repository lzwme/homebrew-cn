cask "microsoft-teams-classic" do
  version "1.7.00.151"
  sha256 "6877a6762ca6219b0c69b70a3154956d8947943a4ab931fbec83d9a88630dc6c"

  url "https:statics.teams.cdn.office.netproduction-osx#{version}Teams_osx.pkg",
      verified: "statics.teams.cdn.office.netproduction-osx"
  name "Microsoft Teams Classic"
  desc "Meet, chat, call, and collaborate in just one place"
  homepage "https:www.microsoft.comen-usmicrosoft-teamsgroup-chat-software"

  # Microsoft releases multiple versions and builds of Teams, as listed here:
  #   https:raw.githubusercontent.comItzLevvieMicrosoftTeams-msinternalmasterdefconfig
  # and here:
  #   https:raw.githubusercontent.comItzLevvieMicrosoftTeams-msinternalmasterdefconfig2
  #
  # We only track the "production build""Public (R4) build" version,
  # which agrees with the version reported by `livecheck`.
  #
  # Any pull request that updates this Cask to a version that
  # differs from the `livecheck` version will be closed.
  livecheck do
    url "https:aka.msteamsmac"
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
              "ApplicationsMicrosoft Teams classic.app",
              "LibraryLogsMicrosoftTeams",
              "LibraryPreferencescom.microsoft.teams.plist",
            ]

  zap trash: [
        "~LibraryApplication Supportcom.microsoft.teams",
        "~LibraryApplication SupportMicrosoftTeams",
        "~LibraryApplication SupportTeams",
        "~LibraryCachescom.microsoft.teams",
        "~LibraryCookiescom.microsoft.teams.binarycookies",
        "~LibraryLogsMicrosoft Teams",
        "~LibraryPreferencescom.microsoft.teams.plist",
        "~LibrarySaved Application Statecom.microsoft.teams.savedState",
        "~LibraryWebKitcom.microsoft.teams",
      ],
      rmdir: "~LibraryApplication SupportMicrosoft"
end