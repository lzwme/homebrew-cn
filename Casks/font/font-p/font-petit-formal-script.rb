cask "font-petit-formal-script" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpetitformalscriptPetitFormalScript-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Petit Formal Script"
  homepage "https:fonts.google.comspecimenPetit+Formal+Script"

  font "PetitFormalScript-Regular.ttf"

  # No zap stanza required
end