cask "crystalfetch" do
  version "2.1.0"
  sha256 "a2791be006e92496c2871caeee557950ecba620c6394075071938ce31051459d"

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