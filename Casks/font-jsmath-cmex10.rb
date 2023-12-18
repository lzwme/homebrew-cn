cask "font-jsmath-cmex10" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapachejsmathcmex10jsMath-cmex10.ttf",
      verified: "github.comgooglefonts"
  name "jsMath cmex10"
  homepage "https:fonts.google.comspecimenjsMath+cmex10"

  font "jsMath-cmex10.ttf"

  # No zap stanza required
end