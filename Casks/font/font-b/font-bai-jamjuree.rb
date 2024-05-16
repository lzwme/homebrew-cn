cask "font-bai-jamjuree" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbaijamjuree"
  name "Bai Jamjuree"
  homepage "https:fonts.google.comspecimenBai+Jamjuree"

  font "BaiJamjuree-Bold.ttf"
  font "BaiJamjuree-BoldItalic.ttf"
  font "BaiJamjuree-ExtraLight.ttf"
  font "BaiJamjuree-ExtraLightItalic.ttf"
  font "BaiJamjuree-Italic.ttf"
  font "BaiJamjuree-Light.ttf"
  font "BaiJamjuree-LightItalic.ttf"
  font "BaiJamjuree-Medium.ttf"
  font "BaiJamjuree-MediumItalic.ttf"
  font "BaiJamjuree-Regular.ttf"
  font "BaiJamjuree-SemiBold.ttf"
  font "BaiJamjuree-SemiBoldItalic.ttf"

  # No zap stanza required
end