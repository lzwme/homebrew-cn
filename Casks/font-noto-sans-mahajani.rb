cask "font-noto-sans-mahajani" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansmahajaniNotoSansMahajani-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Mahajani"
  homepage "https:fonts.google.comspecimenNoto+Sans+Mahajani"

  font "NotoSansMahajani-Regular.ttf"

  # No zap stanza required
end