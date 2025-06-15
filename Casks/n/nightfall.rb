cask "nightfall" do
  version "3.1.0"
  sha256 "b98e86466bb89b04b9f5d3f98e4b74c03950052e8821b515ec1ea0c7f71bef6a"

  url "https:github.comr-thomsonNightfallreleasesdownloadv#{version}Nightfall.dmg"
  name "Nightfall"
  desc "Menu bar utility for toggling dark mode"
  homepage "https:github.comr-thomsonNightfall"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :catalina"

  app "Nightfall.app"

  zap trash: [
    "~LibraryApplication Scriptscom.ryanthomson.Nightfall",
    "~LibraryContainerscom.ryanthomson.Nightfall",
  ]
end