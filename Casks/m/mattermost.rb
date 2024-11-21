cask "mattermost" do
  arch arm: "m1", intel: "x64"

  version "5.10.1"
  sha256 arm:   "4a17032900cf18aba42ff16f970c463b56655552896ebae7e55fc3b6ea93461a",
         intel: "ccc03196391cc3e9ba158e342348eb7a6b9bf80c9c07b57cd614edbf762c6777"

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