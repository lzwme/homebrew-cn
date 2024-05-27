cask "universal-media-server" do
  arch arm: "-arm"

  version "14.0.0"
  sha256 arm:   "4daf2bf86466512fdc829677f342806517726835912e5a080d0398cfbfc7b0d4",
         intel: "a5609c5c530e7703edc2dc88f531cbfdfc290cb74b6ffdc4d125f0371f9120ab"

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