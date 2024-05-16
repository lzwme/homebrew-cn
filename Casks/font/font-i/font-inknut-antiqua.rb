cask "font-inknut-antiqua" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflinknutantiqua"
  name "Inknut Antiqua"
  homepage "https:fonts.google.comspecimenInknut+Antiqua"

  font "InknutAntiqua-Black.ttf"
  font "InknutAntiqua-Bold.ttf"
  font "InknutAntiqua-ExtraBold.ttf"
  font "InknutAntiqua-Light.ttf"
  font "InknutAntiqua-Medium.ttf"
  font "InknutAntiqua-Regular.ttf"
  font "InknutAntiqua-SemiBold.ttf"

  # No zap stanza required
end