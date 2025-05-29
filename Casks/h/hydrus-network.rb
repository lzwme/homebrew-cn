cask "hydrus-network" do
  version "624"
  sha256 "0ba00cdfe79c6a6d014571a8dbe29dd689f2afd82186ff06d965e55b754927b2"

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