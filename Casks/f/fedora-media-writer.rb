cask "fedora-media-writer" do
  arch arm: "-arm64"

  version "5.1.2"
  sha256 arm:   "b008bccf7709ebab6c3e376d68913e2cfd437dd55e6408cd311a3fc8a31793fa",
         intel: "f3f1cbe6a5f039b54f553caf2126f4b5c5b0852becf6f0d0f37e981788b3d259"

  url "https:github.comFedoraQtMediaWriterreleasesdownload#{version}FedoraMediaWriter-osx#{arch}-#{version}.dmg",
      verified: "github.comFedoraQtMediaWriter"
  name "Fedora Media Writer"
  desc "Tool to write Fedora images to portable media files"
  homepage "https:docs.fedoraproject.orgen-USquick-docscreating-and-using-a-live-installation-image"

  depends_on macos: ">= :mojave"

  app "FedoraMediaWriter.app"

  zap trash: "~LibrarySaved Application Stateorg.fedoraproject.MediaWriter.savedState"
end