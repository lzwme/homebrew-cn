cask "shattered-pixel-dungeon" do
  version "2.5.2"
  sha256 "128869b125ec2b5041453083ffbf1c385e9c7a8f2a1c2b73142088cd6e64fbf7"

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