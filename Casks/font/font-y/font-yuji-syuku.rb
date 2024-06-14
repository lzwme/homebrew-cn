cask "font-yuji-syuku" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflyujisyukuYujiSyuku-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Yuji Syuku"
  homepage "https:fonts.google.comspecimenYuji+Syuku"

  font "YujiSyuku-Regular.ttf"

  # No zap stanza required
end