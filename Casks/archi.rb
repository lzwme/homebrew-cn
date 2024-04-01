cask "archi" do
  arch arm: "-Silicon", intel: ""

  version "5.3.0"
  sha256 arm:   "89ccc8526d4b0808d828ec875db14281bfb3a14c7101348e56407c2dd93ba714",
         intel: "74bd5cec8adb0cc63f59b8a3421d5d0a60ab4504218f87e318dfba9b5f4e8ced"

  url "https:www.archimatetool.comdownloadsarchi#{version}Archi-Mac-#{version}#{arch}.dmg"
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