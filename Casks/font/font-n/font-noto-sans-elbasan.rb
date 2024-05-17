cask "font-noto-sans-elbasan" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanselbasanNotoSansElbasan-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Elbasan"
  homepage "https:fonts.google.comspecimenNoto+Sans+Elbasan"

  font "NotoSansElbasan-Regular.ttf"

  # No zap stanza required
end