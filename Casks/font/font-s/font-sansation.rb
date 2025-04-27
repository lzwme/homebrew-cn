cask "font-sansation" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsansation"
  name "Sansation"
  homepage "https:fonts.google.comspecimenSansation"

  font "Sansation-Bold.ttf"
  font "Sansation-BoldItalic.ttf"
  font "Sansation-Italic.ttf"
  font "Sansation-Light.ttf"
  font "Sansation-LightItalic.ttf"
  font "Sansation-Regular.ttf"

  # No zap stanza required
end