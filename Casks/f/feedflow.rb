cask "feedflow" do
  version "1.0.95"
  sha256 "7fcd2b97a4f80d67c526900c5d71b11a84c607017cfc1a8b9467a3587f4caedf"

  url "https:github.comprof18feed-flowreleasesdownload#{version}-desktopFeedFlow-#{version}.dmg",
      verified: "github.comprof18feed-flow"
  name "FeedFlow"
  desc "RSS reader"
  homepage "https:www.feedflow.dev"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"
  depends_on arch: :arm64

  app "FeedFlow.app"

  zap trash: [
    "~LibraryApplication SupportFeedFlow",
    "~LibrarySaved Application Statecom.prof18.feedflow.savedState",
  ]
end