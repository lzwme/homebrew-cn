cask "font-pinyon-script" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpinyonscriptPinyonScript-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Pinyon Script"
  homepage "https:fonts.google.comspecimenPinyon+Script"

  font "PinyonScript-Regular.ttf"

  # No zap stanza required
end