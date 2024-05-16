cask "font-jacques-francois" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofljacquesfrancoisJacquesFrancois-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Jacques Francois"
  homepage "https:fonts.google.comspecimenJacques+Francois"

  font "JacquesFrancois-Regular.ttf"

  # No zap stanza required
end