cask "follow@nightly" do
  arch arm: "arm64", intel: "x64"

  version "0.3.1-nightly.20250114"
  sha256 arm:   "4dcca5eae68a2de90e782608557e2826207a5896c3858a1671d278519adaacd3",
         intel: "15d0ec3a1f7a4befb2813fff82449f91b31e0a6689e29fb61857f31d0b6edcf8"

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