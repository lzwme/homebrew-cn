cask "font-syne" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsyneSyne%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Syne"
  desc "Typeface originally designed for the art center Synesthésie"
  homepage "https:fonts.google.comspecimenSyne"

  font "Syne[wght].ttf"

  # No zap stanza required
end