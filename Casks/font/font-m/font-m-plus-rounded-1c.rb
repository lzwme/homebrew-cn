cask "font-m-plus-rounded-1c" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflmplusrounded1c"
  name "M PLUS Rounded 1c"
  homepage "https:fonts.google.comspecimenM+PLUS+Rounded+1c"

  font "MPLUSRounded1c-Black.ttf"
  font "MPLUSRounded1c-Bold.ttf"
  font "MPLUSRounded1c-ExtraBold.ttf"
  font "MPLUSRounded1c-Light.ttf"
  font "MPLUSRounded1c-Medium.ttf"
  font "MPLUSRounded1c-Regular.ttf"
  font "MPLUSRounded1c-Thin.ttf"

  # No zap stanza required
end