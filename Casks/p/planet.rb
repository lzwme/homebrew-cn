cask "planet" do
  version "0.17.1"
  sha256 "c725bf91bb511260ff2cb44968b2f74a3f82d2b5345d0b0bb41bbb3b6c5ea453"

  url "https:github.comPlanetablePlanetreleasesdownloadrelease-#{version}Planet.zip",
      verified: "github.comPlanetablePlanet"
  name "Planet"
  desc "Decentralised blogs and websites powered by IPFS and Ethereum Name System"
  homepage "https:www.planetable.xyz"

  livecheck do
    url :url
    regex(^release-(\d+(?:[.-]\d+)+)$i)
  end

  auto_updates true

  app "Planet.app"

  zap trash: "~LibraryContainersxyz.planetable.Planet"
end