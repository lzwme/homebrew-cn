cask "archi" do
  arch arm: "-Silicon", intel: ""

  version "5.7.0"
  sha256 arm:   "dbfc38f9a29f8df4c62e38e5fe73a8b85b67bfbfe48e67dece4ae649ae1a6e57",
         intel: "c0896127a5e684be6b31be73c07258c1a982c15d773cae77c22f6e1172206b92"

  url "https://ghfast.top/https://github.com/archimatetool/archi.io/releases/download/57/Archi-Mac#{arch}-#{version}.dmg",
      verified: "github.com/archimatetool/archi.io/"
  name "Archi"
  desc "ArchiMate Modelling Tool"
  homepage "https://www.archimatetool.com/"

  livecheck do
    strategy :page_match
    url "https://github.com/archimatetool/archi/releases.atom"
    regex(%r{releases/tag/release_(.*)"}i)
  end

  app "Archi.app"
end