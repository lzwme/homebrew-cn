cask "mcreator" do
  version "2023.3.36712"
  sha256 "e0cbb76b9d73fbf5b54df5381832b8071b94a75d23cc31d3db4438247c660691"

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