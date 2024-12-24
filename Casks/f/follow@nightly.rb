cask "follow@nightly" do
  arch arm: "arm64", intel: "x64"

  version "0.2.8-nightly.20241223"
  sha256 arm:   "b88ac58575fd76a5dc8971f3dcdae8dfca42bdee36c56eb3f803700df9d2ff14",
         intel: "7cf827c6ee2784a240c2cfc68082e17d39f36900a1c90a3144f64c24737e9bc3"

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