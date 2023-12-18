cask "font-jsmath-cmmi10" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapachejsmathcmmi10jsMath-cmmi10.ttf",
      verified: "github.comgooglefonts"
  name "jsMath cmmi10"
  homepage "https:fonts.google.comspecimenjsMath+cmmi10"

  font "jsMath-cmmi10.ttf"

  # No zap stanza required
end