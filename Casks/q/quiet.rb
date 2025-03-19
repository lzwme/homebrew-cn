cask "quiet" do
  version "4.0.3"
  sha256 "9ffaf5b0f3023d1344f659567efac4252e8e19f8b31f7bb8d819ba713ba30234"

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