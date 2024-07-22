cask "whalebird" do
  version "6.1.3"
  sha256 "33c7f3abd2bc675f7987f856766b064d769af144e92bb1f6c491ff129e687aac"

  url "https:github.comh3potetowhalebird-desktopreleasesdownloadv#{version}Whalebird-#{version}-mac-universal.dmg",
      verified: "github.comh3potetowhalebird-desktop"
  name "Whalebird"
  desc "Mastodon, Pleroma, and Misskey client"
  homepage "https:whalebird.social"

  app "Whalebird.app"

  zap trash: [
    "~LibraryApplication SupportWhalebird",
    "~LibraryLogsWhalebird",
    "~LibraryPreferencessocial.whalebird.app.plist",
    "~LibrarySaved Application Statesocial.whalebird.app.savedState",
  ]
end