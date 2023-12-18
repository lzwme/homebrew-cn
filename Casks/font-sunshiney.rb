cask "font-sunshiney" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapachesunshineySunshiney-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Sunshiney"
  homepage "https:fonts.google.comspecimenSunshiney"

  font "Sunshiney-Regular.ttf"

  # No zap stanza required
end