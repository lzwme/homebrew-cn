cask "fedora-media-writer" do
  arch arm: "-arm64"

  version "5.2.7"
  sha256 arm:   "8d3e410ee66828a5c22abb433265b458df970c3417364e3f513ff316cb551b0c",
         intel: "86ff320d426cadcb47f611b96f4173bdea3dec4b9a0cecfdb56dc714cab08c2b"

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