cask "font-fredoka" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfredokaFredoka%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Fredoka"
  desc "Led by ben nathan, a typeer design foundry based in israel"
  homepage "https:fonts.google.comspecimenFredoka"

  font "Fredoka[wdth,wght].ttf"

  # No zap stanza required
end