cask "font-rakkas" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrakkasRakkas-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rakkas"
  homepage "https:fonts.google.comspecimenRakkas"

  font "Rakkas-Regular.ttf"

  # No zap stanza required
end