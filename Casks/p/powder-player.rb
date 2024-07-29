cask "powder-player" do
  version "1.60"
  sha256 "66f532b975c12f3d5343e7589dcc6746e1a555416494bd8f6b80642464b7b66a"

  url "https:github.comjarubaPowderPlayerreleasesdownloadv#{version}PowderPlayer_v#{version}.dmg",
      verified: "github.comjarubaPowderPlayer"
  name "Powder Player"
  homepage "https:powder.media"

  app "Powder Player.app"

  caveats do
    requires_rosetta
  end
end