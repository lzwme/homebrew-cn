cask "fedora-media-writer" do
  arch arm: "-arm64"

  version "5.1.1"
  sha256 arm:   "192fc5de90d76e85183b97db45ece0715b6bad7b1902968611879f620ae35f03",
         intel: "84f99e9abcb9dd782836baa046ec651e91afdcf2a0c4e9d521e3378082d8c862"

  url "https:github.comFedoraQtMediaWriterreleasesdownload#{version}FedoraMediaWriter-osx#{arch}-#{version}.dmg",
      verified: "github.comFedoraQtMediaWriter"
  name "Fedora Media Writer"
  desc "Tool to write Fedora images to portable media files"
  homepage "https:docs.fedoraproject.orgen-USquick-docscreating-and-using-a-live-installation-image"

  depends_on macos: ">= :mojave"

  app "FedoraMediaWriter.app"

  zap trash: "~LibrarySaved Application Stateorg.fedoraproject.MediaWriter.savedState"
end