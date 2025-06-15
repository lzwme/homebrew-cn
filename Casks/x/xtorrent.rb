cask "xtorrent" do
  version "2.1,171"
  sha256 "26ea235dcb827c6e58ab3409bec83396e86704d742d517e527016ecd44672379"

  url "http://www.xtorrent.com/Xtorrent#{version.csv.first}(v#{version.csv.second}).dmg"
  name "Xtorrent"
  desc "Torrent client"
  homepage "http://www.xtorrent.com/"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  depends_on macos: "<= :catalina"

  app "Xtorrent.app"
end