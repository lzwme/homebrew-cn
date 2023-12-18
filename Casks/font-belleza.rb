cask "font-belleza" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbellezaBelleza-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Belleza"
  homepage "https:fonts.google.comspecimenBelleza"

  font "Belleza-Regular.ttf"

  # No zap stanza required
end