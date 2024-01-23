cask "marshallofsound-google-play-music-player" do
  version "4.7.1"
  sha256 "de6409bca32072d231ff636b68589329731923239ebf1c36e6f557fa26ebddf6"

  url "https:github.comMarshallOfSoundGoogle-Play-Music-Desktop-Player-UNOFFICIAL-releasesdownloadv#{version}Google.Play.Music.Desktop.Player.OSX.zip",
      verified: "github.comMarshallOfSoundGoogle-Play-Music-Desktop-Player-UNOFFICIAL-"
  name "Google Play Music Desktop Player"
  homepage "https:www.googleplaymusicdesktopplayer.com"

  app "Google Play Music Desktop Player.app"

  uninstall signal: [
    ["TERM", "google-play-music-desktop-player"],
    ["TERM", "google-play-music-desktop-player.helper"],
  ]

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsgoogle-play-music-desktop-player.sfl*",
    "~LibraryApplication SupportGoogle Play Music Desktop Player",
    "~LibraryApplication Supportgoogle-play-music-desktop-player.ShipIt",
    "~LibraryCachesGoogle Play Music Desktop Player",
    "~LibraryCachesgoogle-play-music-desktop-player",
    "~LibraryCachesgoogle-play-music-desktop-player.ShipIt",
    "~LibraryCookiesgoogle-play-music-desktop-player.binarycookies",
    "~LibraryLogsGoogle Play Music Desktop Player",
    "~LibraryPreferencesgoogle-play-music-desktop-player.helper.plist",
    "~LibraryPreferencesgoogle-play-music-desktop-player.plist",
    "~LibrarySaved Application Stategoogle-play-music-desktop-player.savedState",
  ]
end