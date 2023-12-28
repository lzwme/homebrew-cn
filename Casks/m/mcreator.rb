cask "mcreator" do
  version "2023.4.52316"
  sha256 "bb8827e8182fdd61c3355799d789d145dbc5eb8b70b81e25d45b8cf2a35bb509"

  url "https:github.comMCreatorMCreatorreleasesdownload#{version}MCreator.#{version.major_minor}.Mac.64bit.dmg",
      verified: "github.comMCreatorMCreator"
  name "MCreator"
  desc "Software used to make Minecraft Java Edition mods"
  homepage "https:mcreator.net"

  livecheck do
    url "https:mcreator.netchangelog"
    regex(>v?(\d+(?:\.\d+)+)<i)
  end

  app "MCreator.app"

  zap trash: "~.mcreator"
end