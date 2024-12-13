cask "follow" do
  arch arm: "arm64", intel: "x64"

  version "0.2.7-beta.0"
  sha256 arm:   "6c7e6e863b457a3a2a8ddea7aa14c9ff74b82081ad2c50c40300a536915393a2",
         intel: "9cb291ef3bded48afd40d2af0e8817f4286b14fa219440c5d357696511c4d7e9"

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