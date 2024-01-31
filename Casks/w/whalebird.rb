cask "whalebird" do
  version "6.0.1"
  sha256 "2a311b4ff77d75437a29988261967ddd9caaf724e015c37697cfdf3b52b212a0"

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