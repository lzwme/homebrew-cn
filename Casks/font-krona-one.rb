cask "font-krona-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflkronaoneKronaOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Krona One"
  homepage "https:fonts.google.comspecimenKrona+One"

  font "KronaOne-Regular.ttf"

  # No zap stanza required
end