cask "archi" do
  arch arm: "-Silicon", intel: ""

  version "5.6.0"
  sha256 arm:   "6bcd10c894fe9a2cd3e1bc6127fd6b5e74066ead19c709aa6fbe27d901f81f72",
         intel: "35958c4332ec3dc27b719a18154c57c4b22eef20881c4e69c3df94aa3b46ec27"

  url "https:www.archimatetool.comdownloadsarchi#{version}Archi-Mac#{arch}-#{version}.dmg"
  name "archi"
  desc "ArchiMate Modelling Tool"
  homepage "https:www.archimatetool.com"

  livecheck do
    strategy :page_match
    url "https:github.comarchimatetoolarchireleases.atom"
    regex(%r{releasestagrelease_(.*)"}i)
  end

  app "Archi.app"
end