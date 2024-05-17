cask "openboard" do
  version "1.7.1"
  sha256 "d892ffd42d028b447b0bbf0cd955ec4beb32159e42168d01c4cc246b9cc2397a"

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