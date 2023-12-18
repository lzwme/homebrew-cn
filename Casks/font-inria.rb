cask "font-inria" do
  version :latest
  sha256 :no_check

  url "https:github.comBlackFoundryInriaFontsarchivemaster.zip",
      verified: "github.comBlackFoundryInriaFonts"
  name "Inria"
  homepage "https:black-foundry.combloginria-serif-and-inria"

  font "InriaFonts-masterfontsInriaSansOTFInriaSans-Bold.otf"
  font "InriaFonts-masterfontsInriaSansOTFInriaSans-BoldItalic.otf"
  font "InriaFonts-masterfontsInriaSansOTFInriaSans-Italic.otf"
  font "InriaFonts-masterfontsInriaSansOTFInriaSans-Light.otf"
  font "InriaFonts-masterfontsInriaSansOTFInriaSans-LightItalic.otf"
  font "InriaFonts-masterfontsInriaSansOTFInriaSans-Regular.otf"
  font "InriaFonts-masterfontsInriaSerifOTFInriaSerif-Bold.otf"
  font "InriaFonts-masterfontsInriaSerifOTFInriaSerif-BoldItalic.otf"
  font "InriaFonts-masterfontsInriaSerifOTFInriaSerif-Italic.otf"
  font "InriaFonts-masterfontsInriaSerifOTFInriaSerif-Light.otf"
  font "InriaFonts-masterfontsInriaSerifOTFInriaSerif-LightItalic.otf"
  font "InriaFonts-masterfontsInriaSerifOTFInriaSerif-Regular.otf"

  # No zap stanza required
end