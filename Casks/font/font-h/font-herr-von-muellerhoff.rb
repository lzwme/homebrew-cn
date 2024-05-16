cask "font-herr-von-muellerhoff" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflherrvonmuellerhoffHerrVonMuellerhoff-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Herr Von Muellerhoff"
  homepage "https:fonts.google.comspecimenHerr+Von+Muellerhoff"

  font "HerrVonMuellerhoff-Regular.ttf"

  # No zap stanza required
end