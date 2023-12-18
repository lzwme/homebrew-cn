cask "shimeike-formulatepro" do
  version "0.0.6"
  sha256 "9a5c37bad02a9dea7448e4ebe6fc6b0887efa05b0530603b9be1e5b0b3db2542"

  url "https:github.comshimeikeformulateproreleasesdownloadv#{version}aFormulatePro-#{version}.dmg"
  name "FormulatePro"
  desc "Overlays text and graphics on PDF documents"
  homepage "https:github.comshimeikeformulatepro"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)[a-z]?$i)
  end

  app "FormulatePro.app"
end