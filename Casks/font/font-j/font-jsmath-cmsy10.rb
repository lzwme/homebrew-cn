cask "font-jsmath-cmsy10" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapachejsmathcmsy10jsMath-cmsy10.ttf",
      verified: "github.comgooglefonts"
  name "jsMath cmsy10"
  homepage "https:fonts.google.comspecimenjsMath+cmsy10"

  font "jsMath-cmsy10.ttf"

  # No zap stanza required
end