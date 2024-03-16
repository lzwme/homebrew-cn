cask "mattermost" do
  arch arm: "m1", intel: "x64"

  version "5.7.0"
  sha256 arm:   "f66ceaf96d5830cba8473ec34332133017244953dfd56de61ba939248a8f9c00",
         intel: "28e5af1f5fc6a133a6fa2b96e3e0398da51f2ba6cb3945e719675f4f3cd17e82"

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