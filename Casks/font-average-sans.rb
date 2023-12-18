cask "font-average-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflaveragesansAverageSans-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Average Sans"
  homepage "https:fonts.google.comspecimenAverage+Sans"

  font "AverageSans-Regular.ttf"

  # No zap stanza required
end