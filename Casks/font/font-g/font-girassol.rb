cask "font-girassol" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgirassolGirassol-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Girassol"
  homepage "https:fonts.google.comspecimenGirassol"

  font "Girassol-Regular.ttf"

  # No zap stanza required
end