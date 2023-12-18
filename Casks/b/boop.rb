cask "boop" do
  version "1.4.0"
  sha256 "8c4492baf6d5b1d26d157877f53d063259e615d784e8ab4d046d3ee67fb9b345"

  url "https:github.comIvanMathyBoopreleasesdownload#{version}Boop.zip",
      verified: "github.comIvanMathyBoop"
  name "Boop"
  desc "Scriptable scratchpad for developers"
  homepage "https:boop.okat.best"

  livecheck do
    url "https:boop.okat.bestversion.json"
    strategy :json do |json|
      json["standalone"]["version"]
    end
  end

  depends_on macos: ">= :mojave"

  app "Boop.app"

  zap trash: [
    "~LibraryApplication Scriptscom.okatbest.boop",
    "~LibraryContainerscom.okatbest.boop",
  ]
end