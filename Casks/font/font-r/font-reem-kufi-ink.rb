cask "font-reem-kufi-ink" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflreemkufiinkReemKufiInk-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Reem Kufi Ink"
  homepage "https:fonts.google.comspecimenReem+Kufi+Ink"

  font "ReemKufiInk-Regular.ttf"

  # No zap stanza required
end