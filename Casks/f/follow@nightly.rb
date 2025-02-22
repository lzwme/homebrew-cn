cask "follow@nightly" do
  arch arm: "arm64", intel: "x64"

  version "0.3.6"
  sha256 arm:   "d6e36564d615fe59efd03a3d38f1a52e52190a049700ae9b1919a1742796ba81",
         intel: "2ea63ebc257b5ebace38e33ff93223676b78d8cbcd5bb5759bdb426297344a3d"

  url "https:github.comRSSNextFollowreleasesdownloadv#{version}Follow-#{version}-macos-#{arch}.dmg",
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