cask "powder-player" do
  version "1.60"
  sha256 "66f532b975c12f3d5343e7589dcc6746e1a555416494bd8f6b80642464b7b66a"

  url "https://ghfast.top/https://github.com/jaruba/PowderPlayer/releases/download/v#{version}/PowderPlayer_v#{version}.dmg",
      verified: "github.com/jaruba/PowderPlayer/"
  name "Powder Player"
  desc "Torrent client and streaming media player"
  homepage "https://powder.media/"

  no_autobump! because: :requires_manual_review

  app "Powder Player.app"

  zap trash: [
    "~/Library/Application Support/Powder-Player",
    "~/Library/Caches/Powder-Player",
    "~/Library/Preferences/media.powder.player.plist",
    "~/Library/Saved Application State/media.powder.player.savedState",
  ]

  caveats do
    requires_rosetta
  end
end