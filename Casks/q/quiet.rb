cask "quiet" do
  version "4.1.2"
  sha256 "9fc296c51f0e9a85bd1e2120643c267098c56ee2289dfe15c2954844b5a73494"

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