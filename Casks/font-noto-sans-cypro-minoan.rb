cask "font-noto-sans-cypro-minoan" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanscyprominoanNotoSansCyproMinoan-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Cypro Minoan"
  desc "Design for the historical european cypro-minoan script"
  homepage "https:fonts.google.comspecimenNoto+Sans+Cypro+Minoan"

  font "NotoSansCyproMinoan-Regular.ttf"

  # No zap stanza required
end