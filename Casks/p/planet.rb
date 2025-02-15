cask "planet" do
  version "0.20.1"
  sha256 "8feb159742cf6af4738c97b60caaa63c0033c21694d5283c73cc9e2b12e29bfb"

  url "https:github.comPlanetablePlanetreleasesdownloadrelease-#{version}Planet.zip",
      verified: "github.comPlanetablePlanet"
  name "Planet"
  desc "Decentralised blogs and websites powered by IPFS and Ethereum Name System"
  homepage "https:www.planetable.xyz"

  livecheck do
    url :url
    regex(^release[._-](\d+(?:[.-]\d+)+)$i)
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Planet.app"

  zap trash: "~LibraryContainersxyz.planetable.Planet"
end