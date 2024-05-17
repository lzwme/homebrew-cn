cask "font-oi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofloiOi-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Oi"
  desc "Interjection used in various languages"
  homepage "https:fonts.google.comspecimenOi"

  font "Oi-Regular.ttf"

  # No zap stanza required
end