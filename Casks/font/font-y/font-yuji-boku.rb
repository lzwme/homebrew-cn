cask "font-yuji-boku" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflyujibokuYujiBoku-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Yuji Boku"
  homepage "https:fonts.google.comspecimenYuji+Boku"

  font "YujiBoku-Regular.ttf"

  # No zap stanza required
end