cask "font-gloock" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgloockGloock-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Gloock"
  homepage "https:fonts.google.comspecimenGloock"

  font "Gloock-Regular.ttf"

  # No zap stanza required
end