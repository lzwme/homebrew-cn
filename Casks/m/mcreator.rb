cask "mcreator" do
  version "2024.1.15821"
  sha256 "b022b03f11084cf50dbeeb2d779e20a3a72392d8d09fc404e8cf76400ea1e91a"

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