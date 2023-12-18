cask "font-emilys-candy" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflemilyscandyEmilysCandy-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Emilys Candy"
  homepage "https:fonts.google.comspecimenEmilys+Candy"

  font "EmilysCandy-Regular.ttf"

  # No zap stanza required
end