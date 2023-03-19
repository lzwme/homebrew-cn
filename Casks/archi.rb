cask "archi" do
  arch arm: "-Silicon", intel: ""

  version "5.0.1"
  sha256 arm:   "d7389380a0b5231e1a86b4e45f5627f8205733119b321755c4af277b0a0a6a49",
         intel: "3131acdd18736ec842b058594c67e76f5a98c8d6053aa7a24e56efb9a2c42dc1"

  url "https://www.archimatetool.com/downloads/archive.php?/#{version}/Archi-Mac-#{version}#{arch}.dmg"
  name "archi"
  desc "ArchiMate Modelling Tool"
  homepage "https://www.archimatetool.com/"

  livecheck do
    strategy :page_match
    url "https://github.com/archimatetool/archi/releases.atom"
    regex(%r{releases/tag/release_(.*)"}i)
  end

  app "Archi.app"
end