cask "follow" do
  arch arm: "arm64", intel: "x64"

  version "0.3.0-beta.0"
  sha256 arm:   "4d83b01ae683ec6ee78617e8684453c78bd36541a2a2d871095859853afb9a1f",
         intel: "45dcc0201d622d5809e1abcd3fbed89452d33ebd1cfbc36e51945abf35fc0b87"

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