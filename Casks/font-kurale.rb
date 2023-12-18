cask "font-kurale" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflkuraleKurale-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Kurale"
  homepage "https:fonts.google.comspecimenKurale"

  font "Kurale-Regular.ttf"

  # No zap stanza required
end