cask "font-lancelot" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllancelotLancelot-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Lancelot"
  homepage "https:fonts.google.comspecimenLancelot"

  font "Lancelot-Regular.ttf"

  # No zap stanza required
end