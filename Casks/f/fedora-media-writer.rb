cask "fedora-media-writer" do
  arch arm: "-arm64"

  version "5.2.0"
  sha256 arm:   "b43394b36484689f925a5bb791728a50441426468f1b1070a41d8811f6b21dc6",
         intel: "084a5e6a610ffe1a469c3665717e198a7395e8400738fcabea0dc753f82aabb1"

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