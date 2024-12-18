cask "openboard" do
  version "1.7.3"
  sha256 "a380cc4b762929f14e71f580b5c6261c5179b770218d0500a64327dc5610e5de"

  url "https:github.comOpenBoard-orgOpenBoardreleasesdownloadv#{version}OpenBoard-#{version}.dmg",
      verified: "github.comOpenBoard-orgOpenBoard"
  name "OpenBoard"
  desc "Interactive whiteboard application"
  homepage "https:openboard.chindex.en.html"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "OpenBoard.app"

  zap trash: [
    "~LibraryApplication SupportOpenBoard",
    "~MoviesOpenBoard",
    "~MusicOpenBoard",
    "~PicturesOpenBoard",
  ]
end