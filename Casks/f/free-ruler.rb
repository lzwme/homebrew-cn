cask "free-ruler" do
  version "2.0.8"
  sha256 "697482a35fb13cb6f58678b443a57951180ad1046141f0e98d0fc8d1f1d67da6"

  url "https:github.compascalppFreeRulerreleasesdownloadv#{version}free-ruler-#{version}.zip",
      verified: "github.compascalppFreeRuler"
  name "Free Ruler"
  desc "Horizontal and vertical rulers"
  homepage "https:www.pascal.comfreeruler"

  depends_on macos: ">= :mojave"

  app "Free Ruler.app"

  zap trash: "~LibraryContainerscom.pascal.freeruler"
end