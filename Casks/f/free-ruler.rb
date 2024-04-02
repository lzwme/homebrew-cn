cask "free-ruler" do
  version "2.0.7"
  sha256 "cd8890d2c59da41acd45a5cf16c318a21419eb604fa049fc0a55fb151fe26420"

  url "https:github.compascalppFreeRulerreleasesdownloadv#{version}free-ruler-#{version}.zip",
      verified: "github.compascalppFreeRuler"
  name "Free Ruler"
  desc "Horizontal and vertical rulers"
  homepage "https:www.pascal.comfreeruler"

  app "Free Ruler.app"

  zap trash: "~LibraryContainerscom.pascal.freeruler"
end