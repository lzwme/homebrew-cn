cask "webrecorder-player" do
  version "1.8.0"
  sha256 "c7ecc7b19c31814a15a1dc5bff41ac899b239877d5968b057b0946b250aedd3a"

  url "https:github.comwebrecorderwebrecorder-playerreleasesdownloadv#{version}webrecorder-player-#{version}.dmg"
  name "Webrecorder Player"
  homepage "https:github.comwebrecorderwebrecorder-player"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Webrecorder Player.app"

  zap trash: [
    "~LibraryApplication SupportWebrecorder Player",
    "~LibraryPreferencesorg.webrecorder.webrecorderplayer.helper.plist",
    "~LibraryPreferencesorg.webrecorder.webrecorderplayer.plist",
    "~LibrarySaved Application Stateorg.webrecorder.webrecorderplayer.savedState",
  ]
end