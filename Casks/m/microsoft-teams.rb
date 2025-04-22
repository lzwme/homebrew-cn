cask "microsoft-teams" do
  version "25079.2107.3576.1611"
  sha256 "e580d4691c89ba178edd7b494f2fac981e121fac912c4cb592bf9454c15904ae"

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
              "ApplicationsMicrosoft Teams.app",
              "LibraryApplication SupportMicrosoftTeamsUpdaterDaemon",
              "LibraryLogsMicrosoftMSTeams",
              "LibraryLogsMicrosoftTeams",
              "LibraryPreferencescom.microsoft.teams.plist",
            ]

  zap trash: [
        "~LibraryApplication Scripts*.com.microsoft.teams",
        "~LibraryApplication Scriptscom.microsoft.teams*",
        "~LibraryApplication Supportcom.microsoft.teams",
        "~LibraryApplication SupportMicrosoftTeams",
        "~LibraryApplication SupportTeams",
        "~LibraryCachescom.microsoft.teams",
        "~LibraryContainerscom.microsoft.teams*",
        "~LibraryCookiescom.microsoft.teams.binarycookies",
        "~LibraryGroup Containers*.com.microsoft.teams",
        "~LibraryHTTPStoragescom.microsoft.teams",
        "~LibraryHTTPStoragescom.microsoft.teams.binarycookies",
        "~LibraryLogsMicrosoft Teams Helper (Renderer)",
        "~LibraryLogsMicrosoft Teams",
        "~LibraryPreferencescom.microsoft.teams*.plist",
        "~LibrarySaved Application Statecom.microsoft.teams*.savedState",
        "~LibraryWebKitcom.microsoft.teams",
      ],
      rmdir: "~LibraryApplication SupportMicrosoft"
end