cask "font-noto-sans-khojki" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanskhojkiNotoSansKhojki-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Khojki"
  homepage "https:fonts.google.comspecimenNoto+Sans+Khojki"

  font "NotoSansKhojki-Regular.ttf"

  # No zap stanza required
end