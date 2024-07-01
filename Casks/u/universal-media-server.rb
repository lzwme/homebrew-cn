cask "universal-media-server" do
  arch arm: "-arm"

  version "14.1.0"
  sha256 arm:   "2b93198299b356a32f8c846f04402f6cfbece0dc20a17e75ac76bec733c7d1ad",
         intel: "c2fd82d0c67729c2476c718a8ad382df12e14efa2fdfd9bfe16c4d2f2b336585"

  url "https:github.comUniversalMediaServerUniversalMediaServerreleasesdownload#{version}UMS-#{version}#{arch}.dmg",
      verified: "github.comUniversalMediaServerUniversalMediaServer"
  name "Universal Media Server"
  desc "Media server supporting DLNA, UPnP and HTTP(S)"
  homepage "https:www.universalmediaserver.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "Universal Media Server.app"

  zap trash: "~LibraryApplication SupportUMS"
end