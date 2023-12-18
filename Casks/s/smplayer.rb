cask "smplayer" do
  version "23.6.0"
  sha256 "9820ae370d2d695eaa6fdaa4313ec9f791d42a4ead1b5ef3ca4eec78e04bddb3"

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
end