cask "font-praise" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpraisePraise-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Praise"
  desc "Versatile script with variations from casual (non-connecting) to formal appeal"
  homepage "https:fonts.google.comspecimenPraise"

  font "Praise-Regular.ttf"

  # No zap stanza required
end