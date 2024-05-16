cask "font-hahmlet" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflhahmletHahmlet%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Hahmlet"
  desc "Great for any kind of typesetting, print or screen"
  homepage "https:fonts.google.comspecimenHahmlet"

  font "Hahmlet[wght].ttf"

  # No zap stanza required
end