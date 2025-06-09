cask "smplayer" do
  version "25.6.0"
  sha256 "e3176fb0bf73e6ccb4080781d8ef17090d5d36abdd563547856fff0355f0f428"

  url "https:github.comsmplayer-devsmplayerreleasesdownloadv#{version}smplayer-#{version}.dmg",
      verified: "github.comsmplayer-devsmplayer"
  name "SMPlayer"
  desc "Media player with built-in codecs"
  homepage "https:www.smplayer.info"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "SMPlayer.app"

  zap trash: [
    "~LibraryPreferencesinfo.smplayer.SMPlayer.plist",
    "~LibrarySaved Application Stateinfo.smplayer.SMPlayer.savedState",
  ]

  caveats do
    requires_rosetta
  end
end