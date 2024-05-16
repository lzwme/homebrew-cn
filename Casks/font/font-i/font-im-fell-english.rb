cask "font-im-fell-english" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflimfellenglish"
  name "IM Fell English"
  homepage "https:fonts.google.comspecimenIM+Fell+English"

  font "IMFeENit28P.ttf"
  font "IMFeENrm28P.ttf"

  # No zap stanza required
end