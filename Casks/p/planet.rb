cask "planet" do
  version "0.19.2"
  sha256 "4ad33aa4fd4cf69845640089c4e6a863be807b6645792305d99d0c41785866a0"

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