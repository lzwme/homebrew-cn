cask "font-purple-purse" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpurplepursePurplePurse-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Purple Purse"
  homepage "https:fonts.google.comspecimenPurple+Purse"

  font "PurplePurse-Regular.ttf"

  # No zap stanza required
end