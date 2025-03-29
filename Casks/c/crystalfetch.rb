cask "crystalfetch" do
  version "2.2.0"
  sha256 "6e428a419bc5deded21da0c9eafae4507fd5b2fb6e2c8cf8b59f97522f01deee"

  url "https:github.comTuringSoftwareCrystalFetchreleasesdownloadv#{version}CrystalFetch.dmg"
  name "Crystalfetch"
  desc "UI for creating Windows installer ISO from UUPDump"
  homepage "https:github.comTuringSoftwareCrystalFetch"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  app "CrystalFetch.app"

  zap trash: [
    "~LibraryApplication Scriptsllc.turing.CrystalFetch",
    "~LibraryContainersllc.turing.CrystalFetch",
  ]
end