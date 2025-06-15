cask "lyric-fever" do
  version "2.2"
  sha256 "1631c25f3a7bcd965e41d66208fa89b60452eb33a3343c7ffe1fe46df7430cca"

  url "https:github.comaviwadLyricFeverreleasesdownloadv#{version}Lyric.Fever.#{version}.dmg",
      verified: "github.comaviwadLyricFeverreleasesdownload"
  name "Lyric Fever"
  desc "Lyrics for Apple Music and Spotify"
  homepage "https:lyricfever.com"

  livecheck do
    url "https:aviwad.github.ioSpotifyLyricsInMenubarappcast.xml"
    strategy :sparkle
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Lyric Fever.app"

  zap trash: "~LibraryContainersLyric Fever"
end