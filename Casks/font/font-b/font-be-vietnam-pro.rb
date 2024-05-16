cask "font-be-vietnam-pro" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbevietnampro"
  name "Be Vietnam Pro"
  desc "Well suited to tech companies and startups"
  homepage "https:fonts.google.comspecimenBe+Vietnam+Pro"

  font "BeVietnamPro-Black.ttf"
  font "BeVietnamPro-BlackItalic.ttf"
  font "BeVietnamPro-Bold.ttf"
  font "BeVietnamPro-BoldItalic.ttf"
  font "BeVietnamPro-ExtraBold.ttf"
  font "BeVietnamPro-ExtraBoldItalic.ttf"
  font "BeVietnamPro-ExtraLight.ttf"
  font "BeVietnamPro-ExtraLightItalic.ttf"
  font "BeVietnamPro-Italic.ttf"
  font "BeVietnamPro-Light.ttf"
  font "BeVietnamPro-LightItalic.ttf"
  font "BeVietnamPro-Medium.ttf"
  font "BeVietnamPro-MediumItalic.ttf"
  font "BeVietnamPro-Regular.ttf"
  font "BeVietnamPro-SemiBold.ttf"
  font "BeVietnamPro-SemiBoldItalic.ttf"
  font "BeVietnamPro-Thin.ttf"
  font "BeVietnamPro-ThinItalic.ttf"

  # No zap stanza required
end