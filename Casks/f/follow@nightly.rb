cask "follow@nightly" do
  arch arm: "arm64", intel: "x64"

  version "0.2.1-nightly.20241114"
  sha256 arm:   "e3c1a33f8ce26ae329616da778febddf055b6ada1bc37b9c11aa516a64fbfa8d",
         intel: "90d46ace69449f58d02fe51c172cbe11dfcfc3e6f3a6d9eaa167e44948627d5a"

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