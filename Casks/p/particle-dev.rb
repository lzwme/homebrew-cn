cask "particle-dev" do
  version "1.19.0"
  sha256 "5f0c2f461c026a5d59a737a717ceb20caa03389cca7f7a754d3bda101d4c4e4a"

  url "https:github.comparticle-iot-archivedparticle-dev-appreleasesdownloadv#{version}particle-dev-mac-#{version}.zip",
      verified: "github.comparticle-iot-archivedparticle-dev-app"
  name "Particle Dev"
  desc "IDE for programming Particle devices"
  homepage "https:www.particle.ioproductsdevelopment-toolsparticle-desktop-ide"

  app "Particle Dev.app"

  zap trash: [
    "~.particle",
    "~.particledev",
  ]

  caveats do
    discontinued
  end
end