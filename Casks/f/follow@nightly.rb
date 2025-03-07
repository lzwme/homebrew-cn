cask "follow@nightly" do
  arch arm: "arm64", intel: "x64"

  version "0.3.10"
  sha256 arm:   "e9c6a96dd0a234e77f587e3a6b56ae51d5f0e2f3ff291d6d33dca5465eba8a5b",
         intel: "790f22554cb92d9020ad976590800c669fc858712fb01d1b59297608e07f47d2"

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