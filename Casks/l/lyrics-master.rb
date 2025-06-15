cask "lyrics-master" do
  version "2.5.5.4"
  sha256 "99743770dbc45f465a00610f6f00206be1648e4ea15c1c68a43a14a895fae97a"

  url "https:github.comLyricsMasterreleasesreleasesdownloadv#{version}LyricsMaster#{version.no_dots}-macos.dmg",
      verified: "github.comLyricsMasterreleases"
  name "Lyrics Master"
  desc "Find and download lyrics"
  homepage "https:lyricsmaster.appdesktop"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :mojave"

  app "Lyrics Master.app"

  zap trash: [
    "~LibraryCachescom.kenichimaehashi.lyricsmaster",
    "~LibraryPreferencespreferences.lyricsmaster",
    "~LibraryWebKitcom.kenichimaehashi.lyricsmaster",
  ]
end