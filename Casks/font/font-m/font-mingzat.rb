cask "font-mingzat" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmingzatMingzat-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Mingzat"
  homepage "https:fonts.google.comspecimenMingzat"

  font "Mingzat-Regular.ttf"

  # No zap stanza required
end