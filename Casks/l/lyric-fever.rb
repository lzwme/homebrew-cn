cask "lyric-fever" do
  version "2.0"
  sha256 "a98b7189eb8fca68069622152e11bab5e92ca4666a47443d5ad6a6db9759054a"

  url "https:github.comaviwadLyricFeverreleasesdownloadv#{version}Lyric.Fever.#{version}.dmg",
      verified: "github.comaviwadLyricFeverreleasesdownload"
  name "Lyric Fever"
  desc "Lyrics for Apple Music and Spotify"
  homepage "https:lyricfever.com"

  livecheck do
    url "https:aviwad.github.ioSpotifyLyricsInMenubarappcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Lyric Fever.app"

  zap trash: "~LibraryContainersLyric Fever"
end