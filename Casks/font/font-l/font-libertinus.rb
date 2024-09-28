cask "font-libertinus" do
  version "7.051"
  sha256 "250677c929d3775a30913643594379af264ac2ef2801035aa1dcbe30b9be23a6"

  url "https:github.comalerquelibertinusreleasesdownloadv#{version}Libertinus-#{version}.tar.zst"
  name "Libertinus"
  homepage "https:github.comalerquelibertinus"

  font "Libertinus-#{version}staticOTFLibertinusKeyboard-Regular.otf"
  font "Libertinus-#{version}staticOTFLibertinusMath-Regular.otf"
  font "Libertinus-#{version}staticOTFLibertinusMono-Regular.otf"
  font "Libertinus-#{version}staticOTFLibertinusSans-Bold.otf"
  font "Libertinus-#{version}staticOTFLibertinusSans-Italic.otf"
  font "Libertinus-#{version}staticOTFLibertinusSans-Regular.otf"
  font "Libertinus-#{version}staticOTFLibertinusSerif-Bold.otf"
  font "Libertinus-#{version}staticOTFLibertinusSerif-BoldItalic.otf"
  font "Libertinus-#{version}staticOTFLibertinusSerif-Italic.otf"
  font "Libertinus-#{version}staticOTFLibertinusSerif-Regular.otf"
  font "Libertinus-#{version}staticOTFLibertinusSerif-Semibold.otf"
  font "Libertinus-#{version}staticOTFLibertinusSerif-SemiboldItalic.otf"
  font "Libertinus-#{version}staticOTFLibertinusSerifDisplay-Regular.otf"
  font "Libertinus-#{version}staticOTFLibertinusSerifInitials-Regular.otf"

  # No zap stanza required
end