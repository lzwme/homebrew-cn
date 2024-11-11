cask "fedora-media-writer" do
  arch arm: "-arm64"

  version "5.1.3"
  sha256 arm:   "17a5e5f3967a0b271e79ac46986435668dfd34f112c930c1dcc4f3d6b8e4a23c",
         intel: "178b3439670b7801323a88c1637e86667ce9223569dfbf43e07f3d89935d3211"

  url "https:github.comFedoraQtMediaWriterreleasesdownload#{version}FedoraMediaWriter-osx#{arch}-#{version}.dmg",
      verified: "github.comFedoraQtMediaWriter"
  name "Fedora Media Writer"
  desc "Tool to write Fedora images to portable media files"
  homepage "https:docs.fedoraproject.orgen-USquick-docscreating-and-using-a-live-installation-image"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :mojave"

  app "FedoraMediaWriter.app"

  zap trash: [
    "~LibraryCachesfedoraproject.org",
    "~LibrarySaved Application Stateorg.fedoraproject.MediaWriter.savedState",
  ]
end