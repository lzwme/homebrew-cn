cask "font-kulim-park" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflkulimpark"
  name "Kulim Park"
  homepage "https:fonts.google.comspecimenKulim+Park"

  font "KulimPark-Bold.ttf"
  font "KulimPark-BoldItalic.ttf"
  font "KulimPark-ExtraLight.ttf"
  font "KulimPark-ExtraLightItalic.ttf"
  font "KulimPark-Italic.ttf"
  font "KulimPark-Light.ttf"
  font "KulimPark-LightItalic.ttf"
  font "KulimPark-Regular.ttf"
  font "KulimPark-SemiBold.ttf"
  font "KulimPark-SemiBoldItalic.ttf"

  # No zap stanza required
end