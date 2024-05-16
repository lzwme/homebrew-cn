cask "font-hi-melody" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflhimelodyHiMelody-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Hi Melody"
  homepage "https:fonts.google.comspecimenHi+Melody"

  font "HiMelody-Regular.ttf"

  # No zap stanza required
end