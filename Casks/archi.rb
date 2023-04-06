cask "archi" do
  arch arm: "-Silicon", intel: ""

  version "5.0.2"
  sha256 arm:   "acbfb6bf4b7c19fb471f06812457e061319dc1fff533848d465fd02e1c49997f",
         intel: "8739ffceb30c63e755ad6fc1a2913fdbfb7c263ad86132dcc51236627b1e23a9"

  url "https://www.archimatetool.com/downloads/archive.php?/#{version}/Archi-Mac-#{version}#{arch}.dmg"
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