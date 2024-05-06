cask "mcreator" do
  version "2024.1.18518"
  sha256 "979318688d75128fe8acafd215b2b7d53e425abd9ee7cd9e6ce344da625b4883"

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