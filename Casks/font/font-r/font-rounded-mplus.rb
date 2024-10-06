cask "font-rounded-mplus" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflroundedmplus1c"
  name "Rounded Mplus"
  homepage "http:jikasei.mefontrounded-mpl"

  font "RoundedMplus1c-Black.ttf"
  font "RoundedMplus1c-Bold.ttf"
  font "RoundedMplus1c-ExtraBold.ttf"
  font "RoundedMplus1c-Light.ttf"
  font "RoundedMplus1c-Medium.ttf"
  font "RoundedMplus1c-Regular.ttf"
  font "RoundedMplus1c-Thin.ttf"

  # No zap stanza required
end