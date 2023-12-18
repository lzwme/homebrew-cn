cask "xca" do
  version "2.5.0"
  sha256 "0042758b99d09aa254d721e1e94fd97adfc186727891093e9eeec4d18e9d734f"

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