# This cask does not work yet...
cask "ultrastar-creator" do
  version "1.2.0"
  sha256 "7ca4342588b9c32f3f0ee33a964f1562fbe5619dcec3464c7a1e42fcd9ed83c5"

  url "https://downloads.sourceforge.net/usc/UltraStarCreator-1.2.dmg",
      verified: "downloads.sourceforge.net/usc/"
  name "UltraStar Creator"
  desc "Create UltraStar karaoke songs from scratch"
  homepage "https://github.com/UltraStar-Deluxe/UltraStar-Creator"

  app "UltraStarCreator.app"
end