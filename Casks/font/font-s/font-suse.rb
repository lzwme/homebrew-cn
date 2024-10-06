cask "font-suse" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsuseSUSE%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "SUSE"
  homepage "https:fonts.google.comspecimenSUSE"

  font "SUSE[wght].ttf"

  # No zap stanza required
end