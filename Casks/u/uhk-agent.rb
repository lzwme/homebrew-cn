cask "uhk-agent" do
  version "7.0.1"
  sha256 "7482e0e70acac964ddec89afdbfc71e6eeb9906dc1331125ecbafc31a9a31612"

  url "https:github.comUltimateHackingKeyboardagentreleasesdownloadv#{version}UHK.Agent-#{version}-mac.dmg"
  name "Ultimate Hacking Keyboard Agent"
  name "UHK Agent"
  desc "Configuration application for the Ultimate Hacking Keyboard"
  homepage "https:github.comUltimateHackingKeyboardagent"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

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