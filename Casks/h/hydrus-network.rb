cask "hydrus-network" do
  version "565a"
  sha256 "8f3e3e83da59d1d2a35f4839532abf6b4d3b7b99144da484a6b8b3e57957a811"

  url "https:github.comhydrusnetworkhydrusreleasesdownloadv#{version}Hydrus.Network.#{version}.-.macOS.-.App.dmg",
      verified: "github.comhydrusnetworkhydrus"
  name "hydrus network"
  desc "Booru-style media tagger"
  homepage "https:hydrusnetwork.github.iohydrus"

  livecheck do
    url :url
    regex(v?(\d+(?:\.\d+)*[a-z]?)i)
    strategy :github_latest
  end

  app "Hydrus Network.app"

  zap trash: "~LibraryHydrus"
end