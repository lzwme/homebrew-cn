cask "font-single-day" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsingledaySingleDay-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Single Day"
  homepage "https:fonts.google.comspecimenSingle+Day"

  font "SingleDay-Regular.ttf"

  # No zap stanza required
end