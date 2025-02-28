cask "shattered-pixel-dungeon" do
  version "3.0.0"
  sha256 "65160971aee4e7af8c80e2ffac598253564b5f3ff833707ea187b613eef270cd"

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