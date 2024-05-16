cask "font-dhurjati" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldhurjatiDhurjati-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Dhurjati"
  homepage "https:fonts.google.comspecimenDhurjati"

  font "Dhurjati-Regular.ttf"

  # No zap stanza required
end