cask "font-noto-serif-todhri" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoseriftodhriNotoSerifTodhri-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Serif Todhri"
  homepage "https:fonts.google.comspecimenNoto+Serif+Todhri"

  font "NotoSerifTodhri-Regular.ttf"

  # No zap stanza required
end