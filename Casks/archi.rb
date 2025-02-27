cask "archi" do
  arch arm: "-Silicon", intel: ""

  version "5.5.0"
  sha256 arm:   "83914582fef0e07b36e869545c2a55dd542336b59ddf9e6fb71b7a143f380d68",
         intel: "05e40f4ec638a600aca04e0ff9d30a13e3f750ffbc5a25136e25857aca64cec9"

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