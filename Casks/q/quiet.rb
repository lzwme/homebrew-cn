cask "quiet" do
  version "6.6.0"
  sha256 "f24e97dbd1b19796610308fd48a9fa13b2138d7871020b114f975b3f8323801f"

  url "https://ghfast.top/https://github.com/TryQuiet/quiet/releases/download/@quiet/desktop@#{version}/Quiet-#{version}.dmg",
      verified: "github.com/TryQuiet/quiet/"
  name "Quiet"
  desc "Private, p2p alternative to Slack and Discord built on Tor & IPFS"
  homepage "https://tryquiet.org/"

  livecheck do
    url :homepage
    regex(/href=.*?Quiet[._-]v?(\d+(?:\.\d+)+)\.dmg/i)
  end

  app "Quiet.app"

  zap trash: "~/Library/Application Support/Quiet*"

  caveats do
    requires_rosetta
  end
end