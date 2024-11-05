cask "archi" do
  arch arm: "-Silicon", intel: ""

  version "5.4.3"
  sha256 arm:   "59ddce5cc5ae7ecd37472854924be830a1b6c08d6ae343166934e4af38a8e08b",
         intel: "63def0330cdad2347a7315aa9d4223401becb4bb73efc421440f387902aa9387"

  url "https:www.archimatetool.comdownloadsarchi#{version}Archi-Mac#{arch}-#{version}.dmg"
  name "archi"
  desc "ArchiMate Modelling Tool"
  homepage "https:www.archimatetool.com"

  livecheck do
    strategy :page_match
    url "https:github.comarchimatetoolarchireleases.atom"
    regex(%r{releasestagrelease_(.*)"}i)
  end

  app "Archi.app"
end