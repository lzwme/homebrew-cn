cask "font-gugi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgugiGugi-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Gugi"
  homepage "https:fonts.google.comspecimenGugi"

  font "Gugi-Regular.ttf"

  # No zap stanza required
end