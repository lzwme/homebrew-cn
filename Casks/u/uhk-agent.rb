cask "uhk-agent" do
  version "6.0.0"
  sha256 "c147d8648b644bd3b6bfca14052658a4961110ce97009cd00a5ae6f975bec275"

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