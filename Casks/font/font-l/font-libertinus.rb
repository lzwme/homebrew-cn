cask "font-libertinus" do
  version "7.040"
  sha256 "7fe9f022722d1c1cc67dc2c28a110b3bb55bae3575196160d2422c89333b3850"

  url "https:github.comalerquelibertinusreleasesdownloadv#{version}Libertinus-#{version}.tar.xz"
  name "Libertinus"
  desc "Proportional serif typeface inspired by 19th century book type"
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