cask "font-agbalumo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflagbalumoAgbalumo-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Agbalumo"
  desc "Single weight font"
  homepage "https:fonts.google.comspecimenAgbalumo"

  font "Agbalumo-Regular.ttf"

  # No zap stanza required
end