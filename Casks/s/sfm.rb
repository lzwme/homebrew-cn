cask "sfm" do
  version "1.9.7"
  sha256 "bc787951b37efad66f109fb4b79d7d637d2d5e8d72c0e48c0f043599f3629fbd"

  url "https:github.comSagerNetsing-boxreleasesdownloadv#{version}SFM-#{version}-universal.dmg",
      verified: "github.comSagerNetsing-box"
  name "SFM"
  desc "Standalone client for sing-box, the universal proxy platform"
  homepage "https:sing-box.sagernet.org"

  depends_on macos: ">= :ventura"

  app "SFM.app"

  uninstall quit:       "io.nekohasekai.sfa.independent",
            login_item: "SFM"

  zap trash: "~LibraryGroup Containersgroup.io.nekohasekai.sfa"
end