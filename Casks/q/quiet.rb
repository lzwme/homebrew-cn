cask "quiet" do
  version "5.0.1"
  sha256 "e784d3fc3a237ed36d8f227028b88696e216e7063b126a8330e0405956aed83a"

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