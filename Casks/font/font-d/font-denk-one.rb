cask "font-denk-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldenkoneDenkOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Denk One"
  homepage "https:fonts.google.comspecimenDenk+One"

  font "DenkOne-Regular.ttf"

  # No zap stanza required
end