cask "lyricsx" do
  version "1.6.3,2351"
  sha256 "7566809283aecdedd5275ded9180cedb467ce40c524b3297b411fe7abb479391"

  url "https:github.comddddxxxLyricsXreleasesdownloadv#{version.csv.first}LyricsX_#{version.csv.first}+#{version.csv.second}.zip"
  name "LyricsX"
  desc "Lyrics for iTunes, Spotify, Vox and Audirvana Plus"
  homepage "https:github.comddddxxxLyricsX"

  livecheck do
    url "https:ddddxxx.github.ioLyricsXappcast.xml"
    strategy :sparkle
  end

  no_autobump! because: :requires_manual_review

  auto_updates true

  app "LyricsX.app"

  zap trash: [
    "~ddddxxx.LyricsX",
    "~LibraryApplication Scripts3665V726AE.group.ddddxxx.LyricsX",
    "~LibraryApplication Scriptsddddxxx.LyricsX",
    "~LibraryApplication Scriptsddddxxx.LyricsXHelper",
    "~LibraryContainersddddxxx.LyricsX",
    "~LibraryContainersddddxxx.LyricsXHelper",
    "~LibraryGroup Containers3665V726AE.group.ddddxxx.LyricsX",
    "~LibraryPreferencesddddxxx.LyricsX.plist",
  ]
end