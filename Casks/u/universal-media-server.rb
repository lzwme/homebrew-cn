cask "universal-media-server" do
  arch arm: "arm", intel: "x86_64"

  version "14.10.1"
  sha256 arm:   "bd2b3d078b6df6a842c0c8c0d3d0047f342f36363a310c0bd57612e0343139a6",
         intel: "b033de11bec2fe52bbe9a9dd4c80869c82dc6b5fe92075b0ee21ece24c7396e4"

  url "https:github.comUniversalMediaServerUniversalMediaServerreleasesdownload#{version}UMS-macOS-#{version}-#{arch}.dmg",
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