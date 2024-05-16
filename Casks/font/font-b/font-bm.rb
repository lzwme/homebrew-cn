cask "font-bm" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflhannaBM-HANNA.ttf",
      verified: "github.comgooglefonts"
  name "BM"
  homepage "https:fonts.google.comearlyaccess"

  font "BM-HANNA.ttf"

  # No zap stanza required
end