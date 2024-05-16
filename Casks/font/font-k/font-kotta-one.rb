cask "font-kotta-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflkottaoneKottaOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Kotta One"
  homepage "https:fonts.google.comspecimenKotta+One"

  font "KottaOne-Regular.ttf"

  # No zap stanza required
end