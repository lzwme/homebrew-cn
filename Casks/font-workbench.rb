cask "font-workbench" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflworkbenchWorkbench%5BBLED%2CSCAN%5D.ttf",
      verified: "github.comgooglefonts"
  name "Workbench"
  homepage "https:fonts.google.comspecimenWorkbench"

  font "Workbench[BLED,SCAN].ttf"

  # No zap stanza required
end