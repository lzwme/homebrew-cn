cask "feedflow" do
  version "1.0.88"
  sha256 "4c89634bddff0eb7cebd50fe7dcacce4b22c21b54fd53955613f0a7fd534e508"

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