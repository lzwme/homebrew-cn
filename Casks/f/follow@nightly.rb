cask "follow@nightly" do
  arch arm: "arm64", intel: "x64"

  version "0.2.5-nightly.20241205"
  sha256 arm:   "88f81d45f8a5d3b303a1cdc3cbd049d3c3fe784273ad8efc3ea59b86c2290b65",
         intel: "b4adc113abfae66c64f56780a3b2a023ba9c5b62bad3dc2618b672dcc6f96946"

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