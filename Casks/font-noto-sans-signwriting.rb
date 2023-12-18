cask "font-noto-sans-signwriting" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanssignwritingNotoSansSignWriting-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans SignWriting"
  desc "Design for the sign-language signwriting script"
  homepage "https:fonts.google.comspecimenNoto+Sans+SignWriting"

  font "NotoSansSignWriting-Regular.ttf"

  # No zap stanza required
end