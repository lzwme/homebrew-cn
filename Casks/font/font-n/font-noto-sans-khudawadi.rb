cask "font-noto-sans-khudawadi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanskhudawadiNotoSansKhudawadi-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Khudawadi"
  homepage "https:fonts.google.comspecimenNoto+Sans+Khudawadi"

  font "NotoSansKhudawadi-Regular.ttf"

  # No zap stanza required
end