cask "font-pattaya" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpattayaPattaya-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Pattaya"
  homepage "https:fonts.google.comspecimenPattaya"

  font "Pattaya-Regular.ttf"

  # No zap stanza required
end