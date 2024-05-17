cask "font-timmana" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofltimmanaTimmana-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Timmana"
  homepage "https:fonts.google.comspecimenTimmana"

  font "Timmana-Regular.ttf"

  # No zap stanza required
end