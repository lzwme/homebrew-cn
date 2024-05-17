cask "font-taprom" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofltapromTaprom-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Taprom"
  homepage "https:fonts.google.comspecimenTaprom"

  font "Taprom-Regular.ttf"

  # No zap stanza required
end