cask "feedflow" do
  version "1.1.2"
  sha256 "f68785ffda6154226d725a689f77b13afa027f953941a82a2394cf10d1301650"

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