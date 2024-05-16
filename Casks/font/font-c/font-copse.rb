cask "font-copse" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcopseCopse-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Copse"
  homepage "https:fonts.google.comspecimenCopse"

  font "Copse-Regular.ttf"

  # No zap stanza required
end