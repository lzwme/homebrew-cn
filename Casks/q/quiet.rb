cask "quiet" do
  version "3.0.0"
  sha256 "da1ebb0179138a6e6ab8816645104234e24a3ce177ad1af7e535831b6012ba57"

  url "https:github.comTryQuietquietreleasesdownload@quietdesktop@#{version}Quiet-#{version}.dmg",
      verified: "github.comTryQuietquiet"
  name "Quiet"
  desc "Private, p2p alternative to Slack and Discord built on Tor & IPFS"
  homepage "https:tryquiet.org"

  livecheck do
    url :homepage
    regex(href=.*?Quiet[._-]v?(\d+(?:\.\d+)+)\.dmgi)
  end

  depends_on macos: ">= :high_sierra"

  app "Quiet.app"

  zap trash: "~LibraryApplication SupportQuiet*"

  caveats do
    requires_rosetta
  end
end