cask "slack" do
  arch arm: "arm64", intel: "x64"

  on_catalina do
    version "4.33.90"
    sha256 arm:   "8c060d33c7c451b58abaed380da4e6781089530d3b9c12da70e738e27c4eb47c",
           intel: "7e0ba8a18a9cf95090ad80f58437d647eee5d1842ac4f15ea053c16c1629edde"

    url "https://downloads.slack-edge.com/releases/macos/#{version}/prod/#{arch}/Slack-#{version}-macOS.dmg",
        verified: "downloads.slack-edge.com/"

    livecheck do
      skip "Legacy version"
    end
  end
  on_big_sur :or_newer do
    version "4.41.104"
    sha256 arm:   "1e4471237a3ef0efa62ae3e7333c06a5fc21d946f3558016c0e8ab07e4be7bd5",
           intel: "aa885d753d21c84c62ac20496d2cb832ec193ef39463054bd13983289bbfc761"

    url "https://downloads.slack-edge.com/desktop-releases/mac/#{arch}/#{version}/Slack-#{version}-macOS.dmg",
        verified: "downloads.slack-edge.com/"

    livecheck do
      url "https://slack.com/ssb/download-osx"
      strategy :header_match
    end
  end

  name "Slack"
  desc "Team communication and collaboration software"
  homepage "https://slack.com/"

  auto_updates true
  conflicts_with cask: "slack@beta"
  depends_on macos: ">= :catalina"

  app "Slack.app"

  uninstall quit: "com.tinyspeck.slackmacgap"

  zap trash: [
    "~/Library/Application Scripts/com.tinyspeck.slackmacgap",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.tinyspeck.slackmacgap.sfl*",
    "~/Library/Application Support/Slack",
    "~/Library/Caches/com.tinyspeck.slackmacgap*",
    "~/Library/Containers/com.tinyspeck.slackmacgap*",
    "~/Library/Cookies/com.tinyspeck.slackmacgap.binarycookies",
    "~/Library/Group Containers/*.com.tinyspeck.slackmacgap",
    "~/Library/Group Containers/*.slack",
    "~/Library/HTTPStorages/com.tinyspeck.slackmacgap*",
    "~/Library/Logs/Slack",
    "~/Library/Preferences/ByHost/com.tinyspeck.slackmacgap.ShipIt.*.plist",
    "~/Library/Preferences/com.tinyspeck.slackmacgap*",
    "~/Library/Saved Application State/com.tinyspeck.slackmacgap.savedState",
    "~/Library/WebKit/com.tinyspeck.slackmacgap",
  ]
end