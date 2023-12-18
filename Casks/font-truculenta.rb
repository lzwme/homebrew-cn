cask "font-truculenta" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofltruculentaTruculenta%5Bopsz%2Cwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Truculenta"
  desc "For packaging, branding, book covers, illustrated editions, and film titles"
  homepage "https:fonts.google.comspecimenTruculenta"

  font "Truculenta[opsz,wdth,wght].ttf"

  # No zap stanza required
end