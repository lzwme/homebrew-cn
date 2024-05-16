cask "font-jsmath-cmti10" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapachejsmathcmti10jsMath-cmti10.ttf",
      verified: "github.comgooglefonts"
  name "jsMath cmti10"
  homepage "https:fonts.google.comspecimenjsMath+cmti10"

  font "jsMath-cmti10.ttf"

  # No zap stanza required
end