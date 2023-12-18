cask "font-vibur" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflviburVibur-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Vibur"
  homepage "https:fonts.google.comspecimenVibur"

  font "Vibur-Regular.ttf"

  # No zap stanza required
end