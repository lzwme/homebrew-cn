cask "mcreator" do
  version "2024.1.17319"
  sha256 "918a2596fd6d2dba0e43e4f7b9a5fc82d56731b9241f0568890a9e5d1faaaa48"

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