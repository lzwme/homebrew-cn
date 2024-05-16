cask "font-dr-sugiyama" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldrsugiyamaDrSugiyama-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Dr Sugiyama"
  homepage "https:fonts.google.comspecimenDr+Sugiyama"

  font "DrSugiyama-Regular.ttf"

  # No zap stanza required
end