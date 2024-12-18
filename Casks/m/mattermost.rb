cask "mattermost" do
  arch arm: "m1", intel: "x64"

  version "5.10.2"
  sha256 arm:   "e8a1d76e88bb64b313fc8fed47676187691710dc74f240a3db17bbf8faf4eb0d",
         intel: "47371fa62ef12424d01631e6affac61eeec49aba3ea36ec84711ece0a955b5ab"

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