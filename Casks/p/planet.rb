cask "planet" do
  version "0.21.0"
  sha256 "e0db7fb1b0f6dcf6e1e377a30105cbfae2b91d03ca31af025ee5c72f09e361bb"

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