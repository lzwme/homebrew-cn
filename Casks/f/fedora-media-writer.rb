cask "fedora-media-writer" do
  arch arm: "-arm64"

  version "5.0.9"
  sha256 arm:   "aec43572e16f7dc49bd48bd319f25b644ea475b95389322ab6b6cd56044b6fde",
         intel: "888d23f9265fc39525ae4ba5626ecd540bbd0a2984ca3ebaae496512269fb33c"

  url "https:github.comFedoraQtMediaWriterreleasesdownload#{version}FedoraMediaWriter-osx#{arch}-#{version}.dmg",
      verified: "github.comFedoraQtMediaWriter"
  name "Fedora Media Writer"
  desc "Tool to write Fedora images to portable media files"
  homepage "https:docs.fedoraproject.orgen-USquick-docscreating-and-using-a-live-installation-image"

  depends_on macos: ">= :mojave"

  app "FedoraMediaWriter.app"

  zap trash: "~LibrarySaved Application Stateorg.fedoraproject.MediaWriter.savedState"
end