cask "xca" do
  version "2.6.0"
  sha256 "34caf717016921c19707719db35c967c2b18fe59efca76473a9008f7d462ba9b"

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