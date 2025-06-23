cask "feedflow" do
  version "1.2.0"
  sha256 "d0509a2fe08b451a97e41d65d096c4cb06d4dd1267144469c20ba3ac55f98bfb"

  url "https:github.comprof18feed-flowreleasesdownload#{version}-allFeedFlow-#{version}.dmg",
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