cask "mattermost" do
  arch arm: "m1", intel: "x64"

  version "5.10.0"
  sha256 arm:   "bdec8057f10949d83dc7d061d5a6fab9e8a8ede4420b65cb236ca6a606432442",
         intel: "eb4ddb482c54e020f13f44980dc1b0a25c8a950de1c63adcc75ea84cb9c3c83a"

  url "https:releases.mattermost.comdesktop#{version}mattermost-desktop-#{version}-mac-#{arch}.zip"
  name "Mattermost"
  desc "Open-source, self-hosted Slack-alternative"
  homepage "https:mattermost.com"

  # Upstream publishes file links in the description of GitHub releases.
  livecheck do
    url "https:github.commattermostdesktop"
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "Mattermost.app"

  zap trash: [
    "~LibraryApplication SupportMattermost",
    "~LibraryContainersMattermost.Desktop",
    "~LibraryLogsMattermost",
    "~LibraryPreferencesMattermost.Desktop.plist",
    "~LibrarySaved Application StateMattermost.Desktop.savedState",
  ]
end