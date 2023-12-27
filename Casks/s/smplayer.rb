cask "smplayer" do
  version "23.12.0"
  sha256 "617f3e1dc95d1b1bc42d203761e27349b4968849ab1f24c074b74489a446c67b"

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