cask "microsoft-teams" do
  version "24033.812.2721.9190"
  sha256 "523f175c77089beff68179b8f06429467bb0ef183c9767bd75129de5733b8e20"

  url "https:statics.teams.cdn.office.netproduction-osx#{version}MicrosoftTeams.pkg",
      verified: "statics.teams.cdn.office.netproduction-osx"
  name "Microsoft Teams"
  desc "Meet, chat, call, and collaborate in just one place"
  homepage "https:www.microsoft.comenmicrosoft-teamsgroup-chat-software"

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
    url "https:config.teams.microsoft.comconfigv1MicrosoftTeams#{version}?environment=prod&audienceGroup=general&teamsRing=general&agent=TeamsBuilds"
    strategy :json do |json|
      json.dig("BuildSettings", "WebView2", "macOS", "latestVersion")
    end
  end

  auto_updates true
  conflicts_with cask: "microsoft-office-businesspro"
  depends_on cask: "microsoft-auto-update"
  depends_on macos: ">= :big_sur"

  pkg "MicrosoftTeams.pkg",
      choices: [
        {
          "choiceIdentifier" => "com.microsoft.autoupdate",
          "choiceAttribute"  => "selected",
          "attributeSetting" => 0,
        },
      ]

  uninstall launchctl: "com.microsoft.teams.TeamsUpdaterDaemon",
            quit:      "com.microsoft.autoupdate2",
            pkgutil:   [
              "com.microsoft.MSTeamsAudioDevice",
              "com.microsoft.package.Microsoft_AutoUpdate.app",
              "com.microsoft.teams2",
            ],
            delete:    [
              "ApplicationsMicrosoft Teams (work or school).app",
              "LibraryApplication SupportMicrosoftTeamsUpdaterDaemon",
              "LibraryLogsMicrosoftMSTeams",
              "LibraryLogsMicrosoftTeams",
              "LibraryPreferencescom.microsoft.teams.plist",
            ]

  zap trash: [
        "~LibraryApplication Scriptscom.microsoft.teams2",
        "~LibraryApplication Scriptscom.microsoft.teams2.launcher",
        "~LibraryApplication Scriptscom.microsoft.teams2.notificationcenter",
        "~LibraryApplication Supportcom.microsoft.teams",
        "~LibraryApplication SupportMicrosoftTeams",
        "~LibraryApplication SupportTeams",
        "~LibraryCachescom.microsoft.teams",
        "~LibraryContainerscom.microsoft.teams2",
        "~LibraryContainerscom.microsoft.teams2.launcher",
        "~LibraryContainerscom.microsoft.teams2.notificationcenter",
        "~LibraryCookiescom.microsoft.teams.binarycookies",
        "~LibraryGroup Containers*.com.microsoft.teams",
        "~LibraryHTTPStoragescom.microsoft.teams",
        "~LibraryHTTPStoragescom.microsoft.teams.binarycookies",
        "~LibraryLogsMicrosoft Teams Helper (Renderer)",
        "~LibraryLogsMicrosoft Teams",
        "~LibraryPreferencescom.microsoft.teams.plist",
        "~LibrarySaved Application Statecom.microsoft.teams.savedState",
        "~LibrarySaved Application Statecom.microsoft.teams2.savedState",
        "~LibraryWebKitcom.microsoft.teams",
      ],
      rmdir: "~LibraryApplication SupportMicrosoft"
end