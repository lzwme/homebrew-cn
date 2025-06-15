cask "follow@alpha" do
  version "0.0.1-alpha.22"
  sha256 "372d62924841a9082ce618bff2964cf4d0b10706b79da73aa93d51f0432033dc"

  url "https:github.comRSSNextFollowreleasesdownloadv#{version}Follow-#{version}-macos-universal.dmg",
      verified: "github.comRSSNextFollow"
  name "Follow"
  desc "Information browser"
  homepage "https:follow.is"

  no_autobump! because: :requires_manual_review

  disable! date: "2025-01-10", because: :discontinued

  conflicts_with cask: [
    "follow",
    "follow@nightly",
  ]
  depends_on macos: ">= :catalina"

  app "Follow.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsis.follow.sfl*",
    "~LibraryApplication SupportFollow",
    "~LibraryLogsFollow",
    "~LibraryPreferencesis.follow.plist",
    "~LibrarySaved Application Stateis.follow.savedState",
  ]
end