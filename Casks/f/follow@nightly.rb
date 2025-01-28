cask "follow@nightly" do
  arch arm: "arm64", intel: "x64"

  version "0.3.3-nightly.20250127"
  sha256 arm:   "0e028387fbf756d83fac20b9aa87424a1dac20b38cd9e1e677ebdfaa37634639",
         intel: "1f53583e1dbc5052bbc308da255daa936f8be3b5c4271a55e2bdc45bb838299f"

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