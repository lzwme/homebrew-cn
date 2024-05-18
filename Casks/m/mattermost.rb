cask "mattermost" do
  arch arm: "m1", intel: "x64"

  version "5.8.0"
  sha256 arm:   "a3a4822e442e205afce31e6ace9de0a11795bb0c2062dfad289ae01539462fe4",
         intel: "a1c76039946b61b876de96caa614d97aeedeed6b85ea39567ee43f63372df222"

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