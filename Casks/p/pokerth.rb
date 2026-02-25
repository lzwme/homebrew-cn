cask "pokerth" do
  version "2.0.3"
  sha256 "e68096d74ff92e6697b2f6c81c88a70e2285b9a98a835793a42eee9fdd0a0139"

  url "https://downloads.sourceforge.net/pokerth/PokerTH-#{version}.dmg",
      verified: "downloads.sourceforge.net/pokerth/"
  name "PokerTH"
  desc "Free Texas hold'em poker"
  homepage "https://www.pokerth.net/"

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  depends_on macos: ">= :monterey"

  app "pokerth.app"

  zap trash: "~/.pokerth"

  caveats do
    requires_rosetta
  end
end