cask "archi" do
  arch arm: "-Silicon", intel: ""

  version "5.2.0"
  sha256 arm:   "061fb60c5d0984c68e45b8313f6f48130e30cdce5fed757635cc7345bf650cdf",
         intel: "188f5a200630bbad117633746373bde2c54ccc9475fa75f8b7155cbea9f5af9f"

  url "https://www.archimatetool.com/downloads/archi-5.php?/#{version}/Archi-Mac-#{version}#{arch}.dmg"
  name "archi"
  desc "ArchiMate Modelling Tool"
  homepage "https://www.archimatetool.com/"

  livecheck do
    strategy :page_match
    url "https://github.com/archimatetool/archi/releases.atom"
    regex(%r{releases/tag/release_(.*)"}i)
  end

  app "Archi.app"
end