cask "font-lilex" do
  version "2.600"
  sha256 "1bcce6df9692897ae71a061e3d2c0b301cf04a777d99f0a29c76521b5a811f4c"

  url "https://ghfast.top/https://github.com/mishamyrt/Lilex/releases/download/#{version}/Lilex.zip"
  name "Lilex"
  homepage "https://github.com/mishamyrt/Lilex"

  no_autobump! because: :requires_manual_review

  font "ttf/Lilex-Bold.ttf"
  font "ttf/Lilex-BoldItalic.ttf"
  font "ttf/Lilex-ExtraLight.ttf"
  font "ttf/Lilex-ExtraLightItalic.ttf"
  font "ttf/Lilex-Italic.ttf"
  font "ttf/Lilex-Medium.ttf"
  font "ttf/Lilex-MediumItalic.ttf"
  font "ttf/Lilex-Regular.ttf"
  font "ttf/Lilex-Thin.ttf"
  font "ttf/Lilex-ThinItalic.ttf"
  font "variable/Lilex-Italic[wght].ttf"
  font "variable/Lilex[wght].ttf"

  # No zap stanza required
end