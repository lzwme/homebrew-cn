cask "planet" do
  version "0.19.1"
  sha256 "dbc8949f85d9c857aa5e0509bd923da09580c30db517360f8e88f0d112b3a105"

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