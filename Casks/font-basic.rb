cask "font-basic" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbasicBasic-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Basic"
  homepage "https:fonts.google.comspecimenBasic"

  font "Basic-Regular.ttf"

  # No zap stanza required
end