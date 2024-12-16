cask "uhk-agent" do
  version "5.0.0"
  sha256 "cce4490e47ba5d7cfca78c0d5638f4c7200fb8b0e61939c5ea31d6e1886d30c2"

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