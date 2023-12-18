cask "font-long-cang" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllongcangLongCang-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Long Cang"
  homepage "https:fonts.google.comspecimenLong+Cang"

  font "LongCang-Regular.ttf"

  # No zap stanza required
end