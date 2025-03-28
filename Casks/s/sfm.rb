cask "sfm" do
  version "1.11.6"
  sha256 "9e5a1d502738f26cfdaf88d9edb9359da175e3475dce9a77cbe9acd1b5ee47ba"

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