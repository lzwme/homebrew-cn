cask "font-alatsi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflalatsiAlatsi-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Alatsi"
  homepage "https:fonts.google.comspecimenAlatsi"

  font "Alatsi-Regular.ttf"

  # No zap stanza required
end