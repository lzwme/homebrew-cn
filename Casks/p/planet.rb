cask "planet" do
  version "0.19.4"
  sha256 "ce7908a92b3d73d1afbe7a6d7218cba7a5aa7eaf4a7e0fd067dbfc2a1fee9b6b"

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