cask "smplayer" do
  version "24.5.0"
  sha256 "747cbe26b49b87b3c115405670ea128ae673631a478fa104f28033a0b8f5ab40"

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