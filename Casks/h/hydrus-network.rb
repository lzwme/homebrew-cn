cask "hydrus-network" do
  version "627"
  sha256 "3fe0ff13c1e2c9d6a1cc0fe26b281a37d753ed2c66d768948c6202ca963fcbaa"

  url "https:github.comhydrusnetworkhydrusreleasesdownloadv#{version}Hydrus.Network.#{version}.-.macOS.-.App.zip",
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