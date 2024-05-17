cask "font-unica-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflunicaoneUnicaOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Unica One"
  homepage "https:fonts.google.comspecimenUnica+One"

  font "UnicaOne-Regular.ttf"

  # No zap stanza required
end