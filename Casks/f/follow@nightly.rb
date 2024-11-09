cask "follow@nightly" do
  arch arm: "arm64", intel: "x64"

  version "0.2.0-nightly.20241108"
  sha256 arm:   "410edf9b1e1878d6abd27aa9c9815fd95ecfd8e7d23d06ad94bb29ac5000740c",
         intel: "c80753e48536cbb1e95a589e6ca05c30f62e8d27f3bf24ad6125ade72966dfc0"

  url "https:github.comRSSNextFollowreleasesdownloadnightly-#{version}Follow-#{version}-macos-#{arch}.dmg",
      verified: "github.comRSSNextFollow"
  name "Follow Nightly"
  desc "Information browser"
  homepage "https:follow.is"

  livecheck do
    url :url
    regex(^nightly[._-]v?(\d+(?:\.\d+)+(?:[._-]nightly[._-]?\d+)?)$i)
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