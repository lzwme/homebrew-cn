cask "font-junicode" do
  version "2.209"
  sha256 "d2d13b9ab8784aa7b5dc54694884e5d9f2f9453e39dbea8579f8307f5b0798bd"

  url "https:github.compsb1558Junicode-fontreleasesdownloadv#{version}Junicode_#{version}.zip"
  name "Junicode"
  homepage "https:github.compsb1558Junicode-font"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "JunicodeOTFJunicode-Bold.otf"
  font "JunicodeOTFJunicode-BoldItalic.otf"
  font "JunicodeOTFJunicode-Cond.otf"
  font "JunicodeOTFJunicode-CondItalic.otf"
  font "JunicodeOTFJunicode-CondLight.otf"
  font "JunicodeOTFJunicode-CondLightItalic.otf"
  font "JunicodeOTFJunicode-CondMedium.otf"
  font "JunicodeOTFJunicode-CondMediumItalic.otf"
  font "JunicodeOTFJunicode-Exp.otf"
  font "JunicodeOTFJunicode-ExpBold.otf"
  font "JunicodeOTFJunicode-ExpBoldItalic.otf"
  font "JunicodeOTFJunicode-ExpItalic.otf"
  font "JunicodeOTFJunicode-ExpMedium.otf"
  font "JunicodeOTFJunicode-ExpMediumItalic.otf"
  font "JunicodeOTFJunicode-ExpSmBold.otf"
  font "JunicodeOTFJunicode-ExpSmBoldItalic.otf"
  font "JunicodeOTFJunicode-Italic.otf"
  font "JunicodeOTFJunicode-Light.otf"
  font "JunicodeOTFJunicode-LightItalic.otf"
  font "JunicodeOTFJunicode-Medium.otf"
  font "JunicodeOTFJunicode-MediumItalic.otf"
  font "JunicodeOTFJunicode-Regular.otf"
  font "JunicodeOTFJunicode-SmBold.otf"
  font "JunicodeOTFJunicode-SmBoldItalic.otf"
  font "JunicodeOTFJunicode-SmCond.otf"
  font "JunicodeOTFJunicode-SmCondItalic.otf"
  font "JunicodeOTFJunicode-SmCondLight.otf"
  font "JunicodeOTFJunicode-SmCondLightItalic.otf"
  font "JunicodeOTFJunicode-SmCondMedium.otf"
  font "JunicodeOTFJunicode-SmCondMediumItalic.otf"
  font "JunicodeOTFJunicode-SmExp.otf"
  font "JunicodeOTFJunicode-SmExpBold.otf"
  font "JunicodeOTFJunicode-SmExpBoldItalic.otf"
  font "JunicodeOTFJunicode-SmExpItalic.otf"
  font "JunicodeOTFJunicode-SmExpMedium.otf"
  font "JunicodeOTFJunicode-SmExpMediumItalic.otf"
  font "JunicodeOTFJunicode-SmExpSmBold.otf"
  font "JunicodeOTFJunicode-SmExpSmBoldItalic.otf"
  font "JunicodeVARJunicodeVF-Italic.ttf"
  font "JunicodeVARJunicodeVF-Roman.ttf"

  # No zap stanza required
end