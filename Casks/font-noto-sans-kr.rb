cask "font-noto-sans-kr" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanskrNotoSansKR%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans KR"
  desc "Unmodulated (“sans serif”) design for the korean language"
  homepage "https:fonts.google.comspecimenNoto+Sans+KR"

  font "NotoSansKR[wght].ttf"

  # No zap stanza required
end