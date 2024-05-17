cask "font-maitree" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflmaitree"
  name "Maitree"
  homepage "https:fonts.google.comspecimenMaitree"

  font "Maitree-Bold.ttf"
  font "Maitree-ExtraLight.ttf"
  font "Maitree-Light.ttf"
  font "Maitree-Medium.ttf"
  font "Maitree-Regular.ttf"
  font "Maitree-SemiBold.ttf"

  # No zap stanza required
end