cask "planet" do
  version "0.19.0"
  sha256 "074939a5db98efb7c3496d5046c14e2649bf0b837c835e548eca6b88b4b9fdb1"

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