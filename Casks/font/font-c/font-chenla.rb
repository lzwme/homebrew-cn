cask "font-chenla" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflchenlaChenla.ttf",
      verified: "github.comgooglefonts"
  name "Chenla"
  homepage "https:fonts.google.comspecimenChenla"

  font "Chenla.ttf"

  # No zap stanza required
end