cask "hydrus-network" do
  version "573"
  sha256 "7ba1b34ac7f3587bf17d6b1cf78ce5b8f6518f7f322312420b61ba83dd786235"

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