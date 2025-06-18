cask "planet" do
  version "0.21.1"
  sha256 "91261bf4b17d40d040485ad804d9096db22edd6c2462a072d53e4eabcd2356e2"

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