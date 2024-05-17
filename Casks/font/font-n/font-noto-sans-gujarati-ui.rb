cask "font-noto-sans-gujarati-ui" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflnotosansgujaratiui"
  name "Noto Sans Gujarati UI"
  homepage "https:fonts.google.comspecimenNoto+Sans+Gujarati"

  font "NotoSansGujaratiUI-Black.ttf"
  font "NotoSansGujaratiUI-Bold.ttf"
  font "NotoSansGujaratiUI-ExtraBold.ttf"
  font "NotoSansGujaratiUI-ExtraLight.ttf"
  font "NotoSansGujaratiUI-Light.ttf"
  font "NotoSansGujaratiUI-Medium.ttf"
  font "NotoSansGujaratiUI-Regular.ttf"
  font "NotoSansGujaratiUI-SemiBold.ttf"
  font "NotoSansGujaratiUI-Thin.ttf"

  # No zap stanza required
end