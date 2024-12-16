cask "follow@nightly" do
  arch arm: "arm64", intel: "x64"

  version "0.2.7-nightly.20241215"
  sha256 arm:   "338719da32e7d3b89ef395544dfc6ef0acf0f1debe6f3d3c1892a9fb054b1579",
         intel: "9bab6dc570e59ff36a16ddae5386aa2f130047bd97ba77ed93c4d06bb5b957cc"

  url "https:github.comRSSNextFollowreleasesdownload#{version}Follow-#{version}-macos-#{arch}.dmg",
      verified: "github.comRSSNextFollow"
  name "Follow Nightly"
  desc "Information browser"
  homepage "https:follow.is"

  livecheck do
    url :url
    regex(^(?:nightly[._-])?v?(\d+(?:\.\d+)+(?:[._-]nightly[._-]?\d+)?)$i)
  end

  conflicts_with cask: [
    "follow",
    "follow@alpha",
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