cask "particle-dev" do
  version "1.19.0"
  sha256 "5f0c2f461c026a5d59a737a717ceb20caa03389cca7f7a754d3bda101d4c4e4a"

  url "https://ghfast.top/https://github.com/particle-iot-archived/particle-dev-app/releases/download/v#{version}/particle-dev-mac-#{version}.zip",
      verified: "github.com/particle-iot-archived/particle-dev-app/"
  name "Particle Dev"
  desc "IDE for programming Particle devices"
  homepage "https://www.particle.io/products/development-tools/particle-desktop-ide"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Particle Dev.app"

  zap trash: [
    "~/.particle",
    "~/.particledev",
  ]
end