cask "planet" do
  version "0.20.2"
  sha256 "98988af2d9bbf7e8e5e6912ed0a0b80a11eaa3504a603d27aa933ef8d9c2e887"

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