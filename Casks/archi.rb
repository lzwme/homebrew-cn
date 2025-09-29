cask "archi" do
  arch arm: "-Silicon", intel: ""

  version "5.6.0"
  sha256 arm:   "6bcd10c894fe9a2cd3e1bc6127fd6b5e74066ead19c709aa6fbe27d901f81f72",
         intel: "35958c4332ec3dc27b719a18154c57c4b22eef20881c4e69c3df94aa3b46ec27"

  url "https://www.archimatetool.com/downloads/archi/#{version}/Archi-Mac#{arch}-#{version}.dmg"
  name "Archi"
  desc "ArchiMate Modelling Tool"
  homepage "https://www.archimatetool.com/"

  livecheck do
    strategy :page_match
    url "https://github.com/archimatetool/archi/releases.atom"
    regex(%r{releases/tag/release_(.*)"}i)
  end

  app "Archi.app"
end