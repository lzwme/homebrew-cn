cask "mattermost" do
  arch arm: "m1", intel: "x64"

  version "5.8.1"
  sha256 arm:   "5cbae21cf2a56e0c2dafdf35683be7639a049048e389a0ad28a6c873c42bc2e3",
         intel: "42e2a4e4b0c06c0f315e70184e666ff455b8c2bc1e3de7d119c473c5e6e841f8"

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