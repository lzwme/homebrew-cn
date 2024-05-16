cask "shattered-pixel-dungeon" do
  version "2.4.0"
  sha256 "43f7a41a3f73eb1c183785e822e2bfc30db8f99e2c462fc0b25bd15eaab9aa69"

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