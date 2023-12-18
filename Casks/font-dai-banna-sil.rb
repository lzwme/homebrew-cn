cask "font-dai-banna-sil" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofldaibannasil"
  name "Dai Banna SIL"
  homepage "https:fonts.google.comspecimenDai+Banna+SIL"

  font "DaiBannaSIL-Bold.ttf"
  font "DaiBannaSIL-BoldItalic.ttf"
  font "DaiBannaSIL-Italic.ttf"
  font "DaiBannaSIL-Light.ttf"
  font "DaiBannaSIL-LightItalic.ttf"
  font "DaiBannaSIL-Medium.ttf"
  font "DaiBannaSIL-MediumItalic.ttf"
  font "DaiBannaSIL-Regular.ttf"
  font "DaiBannaSIL-SemiBold.ttf"
  font "DaiBannaSIL-SemiBoldItalic.ttf"

  # No zap stanza required
end