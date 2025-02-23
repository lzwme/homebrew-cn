cask "feedflow" do
  version "1.0.94"
  sha256 "b2b27a1beb9bfe2d856faa9b04391a1d3db540c877fba15b448c7e611d823528"

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