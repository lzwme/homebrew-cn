cask "feedflow" do
  version "1.0.77"
  sha256 "699b891da10e6dedd99956c159e444f79a24aa581e5c8c87a76ebd2dac044e84"

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