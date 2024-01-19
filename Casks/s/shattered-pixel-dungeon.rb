cask "shattered-pixel-dungeon" do
  version "2.3.0"
  sha256 "9f0bbf7cd2a7e5f97bb03e7370c31c5121937a450ae8d1673c5c755c3c951e95"

  url "https:github.com00-Evanshattered-pixel-dungeonreleasesdownloadv#{version}ShatteredPD-v#{version}-macOS.zip",
      verified: "github.com00-Evanshattered-pixel-dungeon"
  name "Shattered Pixel Dungeon"
  desc "Traditional roguelike dungeon crawler with randomised levels, enemies and items"
  homepage "https:shatteredpixel.comshatteredpd"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "Shattered Pixel Dungeon.app"

  zap trash: [
    "~LibraryApplication SupportShattered Pixel Dungeon",
    "~LibrarySaved Application Statecom.shatteredpixel.shatteredpixeldungeon.apple.savedState",
  ]
end