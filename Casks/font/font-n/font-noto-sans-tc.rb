cask "font-noto-sans-tc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanstcNotoSansTC%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans TC"
  desc "Unmodulated (“sans serif”) design for languages in taiwan and macau"
  homepage "https:fonts.google.comspecimenNoto+Sans+TC"

  font "NotoSansTC[wght].ttf"

  # No zap stanza required
end