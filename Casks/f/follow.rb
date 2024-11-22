cask "follow" do
  arch arm: "arm64", intel: "x64"

  version "0.2.3-beta.0"
  sha256 arm:   "affd30ff8ac456c630d3dbf9d3ef23a8b1a18828642727a8ae544efc6da921b0",
         intel: "7c60c8ee291606e5ee5e82cb983bfb3eeae60f36193520fa46789e4f7d1ae683"

  url "https:github.comRSSNextFollowreleasesdownloadv#{version}Follow-#{version}-macos-#{arch}.dmg",
      verified: "github.comRSSNextFollow"
  name "Follow"
  desc "Information browser"
  homepage "https:follow.is"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+(?:[._-]beta[._-]?\d+)?)$i)
    strategy :github_latest
  end

  auto_updates true
  conflicts_with cask: [
    "follow@alpha",
    "follow@nightly",
  ]
  depends_on macos: ">= :catalina"

  app "Follow.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsis.follow.sfl*",
    "~LibraryApplication SupportFollow",
    "~LibraryLogsFollow",
    "~LibraryPreferencesis.follow.plist",
    "~LibrarySaved Application Stateis.follow.savedState",
  ]
end