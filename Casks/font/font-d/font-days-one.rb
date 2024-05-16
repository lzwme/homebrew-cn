cask "font-days-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldaysoneDaysOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Days One"
  homepage "https:fonts.google.comspecimenDays+One"

  font "DaysOne-Regular.ttf"

  # No zap stanza required
end