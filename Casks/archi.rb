cask "archi" do
  version "5.0.0"
  sha256 arm:   "4ed1255a9fbf6889282327030fd696fcb642d07b4be06b80bd4f6ed3ece78bf6",
         intel: "2e3f0d874ed211344c0ae00ac28610ff7febcfacaed96a9c09233e5923eadd2f"
  arch arm: "-Silicon", intel: ""
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