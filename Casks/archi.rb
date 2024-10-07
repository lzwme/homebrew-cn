cask "archi" do
  arch arm: "-Silicon", intel: ""

  version "5.4.2"
  sha256 arm:   "d0a678e3838e26ddf97e4781469a3618f2b168a1af0e467f49c0cdaf010b9077",
         intel: "eb170c89b2a7dbc06af7dd6c7f400a8846cd77ab79b2ed3b3995d7147fe54469"

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