cask "font-libertinus" do
  version "7.050"
  sha256 "cbb54c4c482376eb17bb6397494489baacff0755d3864f9b5c772e2f3d43d429"

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