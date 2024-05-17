cask "font-roboto" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflroboto"
  name "Roboto"
  desc "Font with a mechanical skeleton and the forms are largely geometric"
  homepage "https:fonts.google.comspecimenRoboto"

  font "Roboto-Italic[wdth,wght].ttf"
  font "Roboto[wdth,wght].ttf"

  # No zap stanza required
end