cask "font-schibsted-grotesk" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflschibstedgrotesk"
  name "Schibsted Grotesk"
  desc "Digital-first font family crafted for user interfaces"
  homepage "https:fonts.google.comspecimenSchibsted+Grotesk"

  font "SchibstedGrotesk-Italic[wght].ttf"
  font "SchibstedGrotesk[wght].ttf"

  # No zap stanza required
end