cask "sfm" do
  version "1.11.1"
  sha256 "c206249cdd311f8f3922b2de81ebe64ee23c6e87e474d35671d409b738fdca49"

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