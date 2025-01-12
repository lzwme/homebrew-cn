cask "moderndeck" do
  version "10.0.0"
  sha256 "f4f09af5ae7a71bbcb3e660ba6ab664fe33c016bc14f94e129a2013f16e208b6"

  url "https:github.comdangeredwolfModernDeckreleasesdownloadv#{version}ModernDeck-universal.dmg",
      verified: "github.comdangeredwolfModernDeck"
  name "ModernDeck"
  desc "Modified version of TweetDeck with a material inspired theme"
  homepage "https:moderndeck.app"

  deprecate! date: "2024-01-09", because: :discontinued
  disable! date: "2025-01-11", because: :discontinued

  auto_updates true
  depends_on macos: ">= :el_capitan"

  app "ModernDeck.app"

  zap trash: [
    "~LibraryApplication SupportModernDeck",
    "~LibraryLogsModernDeck",
  ]
end