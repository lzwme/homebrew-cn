cask "font-milonga" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmilongaMilonga-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Milonga"
  homepage "https:fonts.google.comspecimenMilonga"

  font "Milonga-Regular.ttf"

  # No zap stanza required
end