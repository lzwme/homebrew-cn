cask "playback" do
  version "1.6.0"
  sha256 "32588de0f9f8c6281cae11e4f64f5f4e4d3919f5d8b94d03be4d8552fbd8f0a8"

  url "https:github.commafintoshplaybackreleasesdownloadv#{version}Playback.app.zip",
      verified: "github.commafintoshplayback"
  name "Playback"
  desc "Video player"
  homepage "https:mafintosh.github.ioplayback"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-28", because: :unmaintained

  app "Playback.app"

  zap trash: [
    "~LibraryApplication Supportplayback",
    "~LibraryCachesplayback",
    "~LibraryPreferencescom.electron.playback.plist",
  ]

  caveats do
    requires_rosetta
  end
end