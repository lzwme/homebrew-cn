cask "archi" do
  version "4.10.0"
  sha256 "d4a0a6284edccdbdb77d2a30461db1ff72ac0489513b26d46383a578abb91096"

  url "https://www.archimatetool.com/downloads/index.php?/downloads/archi/#{version}/Archi-Mac-#{version}.dmg"
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