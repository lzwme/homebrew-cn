cask "font-yuji-mai" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflyujimaiYujiMai-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Yuji Mai"
  homepage "https:fonts.google.comspecimenYuji+Mai"

  font "YujiMai-Regular.ttf"

  # No zap stanza required
end