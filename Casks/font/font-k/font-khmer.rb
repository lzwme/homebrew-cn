cask "font-khmer" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflkhmerKhmer.ttf",
      verified: "github.comgooglefonts"
  name "Khmer"
  homepage "https:fonts.google.comspecimenKhmer"

  font "Khmer.ttf"

  # No zap stanza required
end