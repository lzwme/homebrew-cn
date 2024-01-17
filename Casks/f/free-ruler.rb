cask "free-ruler" do
  version "2.0.6"
  sha256 "ee762183261e58b8b121a09cd282bc63f2b8664f0d1e31d24be2c623c99d01a8"

  url "https:github.compascalppFreeRulerreleasesdownloadv#{version}free-ruler-#{version}.zip",
      verified: "github.compascalppFreeRuler"
  name "Free Ruler"
  desc "Horizontal and vertical rulers"
  homepage "https:www.pascal.comfreeruler"

  app "Free Ruler.app"

  zap trash: "~LibraryContainerscom.pascal.freeruler"
end