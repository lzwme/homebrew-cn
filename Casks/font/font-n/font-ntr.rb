cask "font-ntr" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflntrNTR-Regular.ttf",
      verified: "github.comgooglefonts"
  name "NTR"
  homepage "https:fonts.google.comspecimenNTR"

  font "NTR-Regular.ttf"

  # No zap stanza required
end