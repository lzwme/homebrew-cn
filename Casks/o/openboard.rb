cask "openboard" do
  version "1.7.0"
  sha256 "3a98890712c8c8a517a33d92dbd00c1d4d8b556443bd5bc8cf7e0c459273d05f"

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