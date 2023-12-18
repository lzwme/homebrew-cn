cask "font-eagle-lake" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofleaglelakeEagleLake-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Eagle Lake"
  homepage "https:fonts.google.comspecimenEagle+Lake"

  font "EagleLake-Regular.ttf"

  # No zap stanza required
end