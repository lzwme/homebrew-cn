cask "xca" do
  version "2.8.0"
  sha256 "c53c6cee47572bdfc68d9090c1268e406fdb73384cc240119cf069ac8c8ddf76"

  url "https:github.comchris2511xcareleasesdownloadRELEASE.#{version}xca-#{version}-Darwin.dmg",
      verified: "github.comchris2511xca"
  name "XCA"
  desc "X Certificate and Key management"
  homepage "https:hohnstaedt.dexca"

  livecheck do
    url :url
    regex(^RELEASE\.(\d+(?:\.\d+)*)$i)
  end

  depends_on macos: ">= :big_sur"

  app "xca.app"

  zap trash: [
    "~LibraryApplication Supportxca",
    "~LibrarySaved Application Statede.hohnstaedt.xca.savedState",
  ]
end