cask "font-hanken-grotesk" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflhankengrotesk"
  name "Hanken Grotesk"
  homepage "https:fonts.google.comspecimenHanken+Grotesk"

  font "HankenGrotesk-Italic[wght].ttf"
  font "HankenGrotesk[wght].ttf"

  # No zap stanza required
end