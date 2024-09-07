cask "whalebird" do
  version "6.1.4"
  sha256 "c7b61c1bf79341b61d6ae4fb3458488c43d6222f57bb9dced3c1d57575e88c66"

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