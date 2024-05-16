cask "font-khula" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflkhula"
  name "Khula"
  homepage "https:fonts.google.comspecimenKhula"

  font "Khula-Bold.ttf"
  font "Khula-ExtraBold.ttf"
  font "Khula-Light.ttf"
  font "Khula-Regular.ttf"
  font "Khula-SemiBold.ttf"

  # No zap stanza required
end