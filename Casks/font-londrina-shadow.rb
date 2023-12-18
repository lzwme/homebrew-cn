cask "font-londrina-shadow" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllondrinashadowLondrinaShadow-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Londrina Shadow"
  homepage "https:fonts.google.comspecimenLondrina+Shadow"

  font "LondrinaShadow-Regular.ttf"

  # No zap stanza required
end