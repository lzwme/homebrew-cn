cask "archi" do
  arch arm: "-Silicon", intel: ""

  version "5.1.0"
  sha256 arm:   "a1c114213603ebba9f5772b4da0bcf4b9b52d711ecf3d5b00234949db4543768",
         intel: "1e70307103529520a4e38916a5f9f26772e034b45237ca79bb13555007eee887"

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