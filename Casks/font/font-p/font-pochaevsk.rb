cask "font-pochaevsk" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpochaevskPochaevsk-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Pochaevsk"
  homepage "https:fonts.google.comspecimenPochaevsk"

  font "Pochaevsk-Regular.ttf"

  # No zap stanza required
end