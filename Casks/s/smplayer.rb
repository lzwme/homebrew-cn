cask "smplayer" do
  version "25.6.0"
  sha256 "de88cc07f128f4e99cb36fa0dc5ae38dea261e4d8f51cd0235eca427cb23672e"

  url "https:github.comsmplayer-devsmplayerreleasesdownloadv#{version}smplayer-#{version}.dmg",
      verified: "github.comsmplayer-devsmplayer"
  name "SMPlayer"
  desc "Media player with built-in codecs"
  homepage "https:www.smplayer.info"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "SMPlayer.app"

  zap trash: [
    "~LibraryPreferencesinfo.smplayer.SMPlayer.plist",
    "~LibrarySaved Application Stateinfo.smplayer.SMPlayer.savedState",
  ]

  caveats do
    requires_rosetta
  end
end