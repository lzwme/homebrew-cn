cask "font-potta-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpottaonePottaOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Potta One"
  homepage "https:fonts.google.comspecimenPotta+One"

  font "PottaOne-Regular.ttf"

  # No zap stanza required
end