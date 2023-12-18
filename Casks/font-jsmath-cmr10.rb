cask "font-jsmath-cmr10" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapachejsmathcmr10jsMath-cmr10.ttf",
      verified: "github.comgooglefonts"
  name "jsMath cmr10"
  homepage "https:fonts.google.comspecimenjsMath+cmr10"

  font "jsMath-cmr10.ttf"

  # No zap stanza required
end