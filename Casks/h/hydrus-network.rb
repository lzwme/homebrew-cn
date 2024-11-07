cask "hydrus-network" do
  version "597"
  sha256 "ad7ed99dcaee6ba15ca407c41853564e5a776d028ef34f4ce4daaa2097704e40"

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

  caveats do
    requires_rosetta
  end
end