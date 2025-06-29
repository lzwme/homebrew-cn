cask "font-urw-base35" do
  # NOTE: "35" is not a version number, but an intrinsic part of the product name
  version "20200910"
  sha256 "e0d9b7f11885fdfdc4987f06b2aa0565ad2a4af52b22e5ebf79e1a98abd0ae2f"

  url "https:github.comArtifexSoftwareurw-base35-fontsarchiverefstags#{version}.tar.gz"
  name "URW++ base 35"
  homepage "https:github.comArtifexSoftwareurw-base35-fonts"

  no_autobump! because: :requires_manual_review

  font "urw-base35-fonts-#{version}fontsC059-BdIta.otf"
  font "urw-base35-fonts-#{version}fontsC059-Bold.otf"
  font "urw-base35-fonts-#{version}fontsC059-Italic.otf"
  font "urw-base35-fonts-#{version}fontsC059-Roman.otf"
  font "urw-base35-fonts-#{version}fontsD050000L.otf"
  font "urw-base35-fonts-#{version}fontsNimbusMonoPS-Bold.otf"
  font "urw-base35-fonts-#{version}fontsNimbusMonoPS-BoldItalic.otf"
  font "urw-base35-fonts-#{version}fontsNimbusMonoPS-Italic.otf"
  font "urw-base35-fonts-#{version}fontsNimbusMonoPS-Regular.otf"
  font "urw-base35-fonts-#{version}fontsNimbusRoman-Bold.otf"
  font "urw-base35-fonts-#{version}fontsNimbusRoman-BoldItalic.otf"
  font "urw-base35-fonts-#{version}fontsNimbusRoman-Italic.otf"
  font "urw-base35-fonts-#{version}fontsNimbusRoman-Regular.otf"
  font "urw-base35-fonts-#{version}fontsNimbusSans-Bold.otf"
  font "urw-base35-fonts-#{version}fontsNimbusSans-BoldItalic.otf"
  font "urw-base35-fonts-#{version}fontsNimbusSans-Italic.otf"
  font "urw-base35-fonts-#{version}fontsNimbusSans-Regular.otf"
  font "urw-base35-fonts-#{version}fontsNimbusSansNarrow-Bold.otf"
  font "urw-base35-fonts-#{version}fontsNimbusSansNarrow-BoldOblique.otf"
  font "urw-base35-fonts-#{version}fontsNimbusSansNarrow-Oblique.otf"
  font "urw-base35-fonts-#{version}fontsNimbusSansNarrow-Regular.otf"
  font "urw-base35-fonts-#{version}fontsP052-Bold.otf"
  font "urw-base35-fonts-#{version}fontsP052-BoldItalic.otf"
  font "urw-base35-fonts-#{version}fontsP052-Italic.otf"
  font "urw-base35-fonts-#{version}fontsP052-Roman.otf"
  font "urw-base35-fonts-#{version}fontsStandardSymbolsPS.otf"
  font "urw-base35-fonts-#{version}fontsURWBookman-Demi.otf"
  font "urw-base35-fonts-#{version}fontsURWBookman-DemiItalic.otf"
  font "urw-base35-fonts-#{version}fontsURWBookman-Light.otf"
  font "urw-base35-fonts-#{version}fontsURWBookman-LightItalic.otf"
  font "urw-base35-fonts-#{version}fontsURWGothic-Book.otf"
  font "urw-base35-fonts-#{version}fontsURWGothic-BookOblique.otf"
  font "urw-base35-fonts-#{version}fontsURWGothic-Demi.otf"
  font "urw-base35-fonts-#{version}fontsURWGothic-DemiOblique.otf"
  font "urw-base35-fonts-#{version}fontsZ003-MediumItalic.otf"

  # No zap stanza required
end