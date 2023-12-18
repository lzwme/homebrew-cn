cask "font-marmelad" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmarmeladMarmelad-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Marmelad"
  homepage "https:fonts.google.comspecimenMarmelad"

  font "Marmelad-Regular.ttf"

  # No zap stanza required
end