cask "sfm" do
  version "1.8.11"
  sha256 "6dbce1788616a2ded5c6a18c0af1efa97780c6a1d6254d9c527acc45cdabe2c9"

  url "https:github.comSagerNetsing-boxreleasesdownloadv#{version}SFM-#{version}-universal.zip",
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