cask "font-gideon-roman" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgideonromanGideonRoman-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Gideon Roman"
  homepage "https:fonts.google.comspecimenGideon+Roman"

  font "GideonRoman-Regular.ttf"

  # No zap stanza required
end