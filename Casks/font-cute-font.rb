cask "font-cute-font" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcutefontCuteFont-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Cute Font"
  homepage "https:fonts.google.comspecimenCute+Font"

  font "CuteFont-Regular.ttf"

  # No zap stanza required
end