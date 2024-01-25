cask "whalebird" do
  version "6.0.0"
  sha256 "3d4271fd9e572db851378a04fdfc7f3c60effeb1b5fee0750fe2f0307cd4e524"

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