cask "font-bricolage-grotesque" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbricolagegrotesqueBricolageGrotesque%5Bopsz%2Cwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Bricolage Grotesque"
  desc "Collage of historical sources, technical decisions and personal feelings"
  homepage "https:fonts.google.comspecimenBricolage+Grotesque"

  font "BricolageGrotesque[opsz,wdth,wght].ttf"

  # No zap stanza required
end