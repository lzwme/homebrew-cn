cask "shattered-pixel-dungeon" do
  version "2.4.2"
  sha256 "059ea22a3496ab345fb200bba8a402296f5c1ba7e137033bf51bf008986a70d1"

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

  caveats do
    requires_rosetta
  end
end