cask "fedora-media-writer" do
  arch arm: "-arm64"

  version "5.2.1"
  sha256 arm:   "265494a05c77e7dfe00235e9e37313b1bea1c0d5390cc88a90d94e7ebbc5735b",
         intel: "9926eb53f77b600fb168f71d63ca98fb4e1d16bcdb8c656a5a291b9802eab881"

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