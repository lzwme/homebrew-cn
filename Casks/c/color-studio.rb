cask "color-studio" do
  version "1.0.4"
  sha256 "95cb57fc7fdc8f5d0d3f7016e1b07b536295dc67ee3a7f674a84634e80e4ad63"

  url "https:github.combernaferraricolor-studioreleasesdownload#{version}ColorStudio.zip"
  name "Color Studio"
  desc "Coherent colorscheme creator"
  homepage "https:github.combernaferraricolor-studio"

  app "Color StudioColor Studio.app"

  zap trash: [
    "~LibraryApplication Scriptscom.bernaferrari.colorstudio",
    "~LibraryContainerscom.bernaferrari.colorstudio",
  ]
end