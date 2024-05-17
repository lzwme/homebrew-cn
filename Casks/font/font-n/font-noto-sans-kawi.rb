cask "font-noto-sans-kawi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanskawiNotoSansKawi%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Kawi"
  desc "Design for the historical southeast asian kawi script"
  homepage "https:fonts.google.comspecimenNoto+Sans+Kawi"

  font "NotoSansKawi[wght].ttf"

  # No zap stanza required
end