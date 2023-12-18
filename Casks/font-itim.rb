cask "font-itim" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflitimItim-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Itim"
  homepage "https:fonts.google.comspecimenItim"

  font "Itim-Regular.ttf"

  # No zap stanza required
end