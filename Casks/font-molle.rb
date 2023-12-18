cask "font-molle" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmolleMolle-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Molle"
  homepage "https:fonts.google.comspecimenMolle"

  font "Molle-Regular.ttf"

  # No zap stanza required
end