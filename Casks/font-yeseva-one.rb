cask "font-yeseva-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflyesevaoneYesevaOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Yeseva One"
  homepage "https:fonts.google.comspecimenYeseva+One"

  font "YesevaOne-Regular.ttf"

  # No zap stanza required
end