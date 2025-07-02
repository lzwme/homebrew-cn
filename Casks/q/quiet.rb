cask "quiet" do
  version "6.0.0"
  sha256 "075ad3fba53482349caf514fba1df11b19297ee993ffc7de4c96c46c28173e9a"

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