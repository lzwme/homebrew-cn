cask "uhk-agent" do
  version "5.1.0"
  sha256 "462da267567608ac73c8d2dc607ae8aa70d042c90b2cd5f2aa7aeebc38312d2f"

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