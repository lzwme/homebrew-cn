cask "font-baumans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbaumansBaumans-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Baumans"
  homepage "https:fonts.google.comspecimenBaumans"

  font "Baumans-Regular.ttf"

  # No zap stanza required
end