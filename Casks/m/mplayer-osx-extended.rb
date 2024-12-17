cask "mplayer-osx-extended" do
  version "16"
  sha256 "a52eae9a685a4d9854a5f989c4eb1e94b3f97b8c25a0e36ad4cdbc610fdf1023"

  url "https:github.comsttzMPlayer-OSX-Extendedreleasesdownloadrev#{version}MPlayer-OSX-Extended_rev#{version}.zip",
      verified: "github.comsttzMPlayer-OSX-Extended"
  name "MPlayer OSX Extended"
  desc "Video player that uses MPlayer as backend"
  homepage "https:mplayerosx.ch"

  disable! date: "2024-12-16", because: :discontinued

  app "MPlayer OSX Extended.app"

  zap trash: "~.mplayer"
end