cask "uhk-agent" do
  version "4.1.0"
  sha256 "35761055395f1b5bd5119301a73b804e5a1a3f5b7d239d0ccdfd28fcbc29f91c"

  url "https:github.comUltimateHackingKeyboardagentreleasesdownloadv#{version}UHK.Agent-#{version}-mac.dmg"
  name "Ultimate Hacking Keyboard Agent"
  name "UHK Agent"
  desc "Configuration application for the Ultimate Hacking Keyboard"
  homepage "https:github.comUltimateHackingKeyboardagent"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "UHK Agent.app"

  uninstall quit: "com.ultimategadgetlabs.agent"

  zap trash: [
    "~LibraryApplication Supportuhk-agent",
    "~LibraryLogsUHK Agent",
    "~LibraryLogsuhk-agent",
    "~LibraryPreferencescom.ultimategadgetlabs.agent.helper.plist",
    "~LibraryPreferencescom.ultimategadgetlabs.agent.plist",
    "~LibrarySaved Application Statecom.ultimategadgetlabs.agent.savedState",
  ]
end