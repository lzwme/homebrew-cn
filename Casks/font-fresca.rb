cask "font-fresca" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfrescaFresca-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Fresca"
  homepage "https:fonts.google.comspecimenFresca"

  font "Fresca-Regular.ttf"

  # No zap stanza required
end