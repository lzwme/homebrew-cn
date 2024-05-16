cask "font-biryani" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbiryani"
  name "Biryani"
  homepage "https:fonts.google.comspecimenBiryani"

  font "Biryani-Black.ttf"
  font "Biryani-Bold.ttf"
  font "Biryani-ExtraBold.ttf"
  font "Biryani-ExtraLight.ttf"
  font "Biryani-Light.ttf"
  font "Biryani-Regular.ttf"
  font "Biryani-SemiBold.ttf"

  # No zap stanza required
end