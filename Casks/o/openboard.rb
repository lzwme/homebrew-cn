cask "openboard" do
  version "1.7.2"
  sha256 "c7919219afe4dda3c42001f5d547faf76f808e4df61129b57d7c028ce8477c05"

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