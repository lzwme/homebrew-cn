cask "font-mingzat" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmingzatMingzat-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Mingzat"
  desc "Unicode font based on jason glavy's jg lepcha custom-encoded font"
  homepage "https:fonts.google.comspecimenMingzat"

  font "Mingzat-Regular.ttf"

  # No zap stanza required
end