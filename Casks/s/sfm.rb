cask "sfm" do
  version "1.8.7"
  sha256 "aec974d33f81fba1cf3de65e12df3e69d8598aabee26b56ef961ecc32e858605"

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