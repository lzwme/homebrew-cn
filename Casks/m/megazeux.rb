cask "megazeux" do
  version "2.92f"
  sha256 "1c4807ff44f27a41b1131a08eb42c4d07e783653380150a980f2f9e3d2a4836e"

  url "https:github.comAliceLRmegazeuxreleasesdownloadv#{version}mzx#{version.no_dots}-intel-universal.dmg",
      verified: "github.comAliceLRmegazeux"
  name "MegaZeux"
  desc "ASCII-based game creation system"
  homepage "https:www.digitalmzx.com"

  app "MegaZeux.app"
  artifact "Documentation", target: "~LibraryApplication SupportMegaZeuxDocumentation"

  zap trash: [
    "~.megazeux-config",
    "~LibraryApplication SupportMegaZeux",
  ]
end