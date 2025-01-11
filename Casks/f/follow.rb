cask "follow" do
  arch arm: "arm64", intel: "x64"

  version "0.3.1-beta.0"
  sha256 arm:   "ed08f999dab97bca404e71b78cb7b46e10763997c8afad0dcb5e844f203b53e9",
         intel: "ac6509ebd00edc5816e0c66c36f1796c36353ed7e3a95c10ba4388d02b23d71f"

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
  depends_on macos: ">= :big_sur"

  app "Follow.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsis.follow.sfl*",
    "~LibraryApplication SupportFollow",
    "~LibraryLogsFollow",
    "~LibraryPreferencesis.follow.plist",
    "~LibrarySaved Application Stateis.follow.savedState",
  ]
end