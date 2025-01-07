cask "fedora-media-writer" do
  arch arm: "-arm64"

  version "5.2.3"
  sha256 arm:   "429ae8b8707d28a6e57b8555c9bec1781815e4458818e126cdbc2c5fd5b254e8",
         intel: "1ebef9a3b5898f9d04473313b8adfa4f21215fef255fa27e6f5029cf477c5f58"

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