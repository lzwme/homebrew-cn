cask "follow@nightly" do
  arch arm: "arm64", intel: "x64"

  version "0.2.1-nightly.20241117"
  sha256 arm:   "b2a310760f54536837e8987a51c772adb1f5e496d3d94a150d6d514b8c316986",
         intel: "f725cf963fe058beb39536157a04cb1021f19ec5bc305c6f080c1eaddba4fc10"

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