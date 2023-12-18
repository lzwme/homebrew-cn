cask "font-julee" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofljuleeJulee-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Julee"
  homepage "https:fonts.google.comspecimenJulee"

  font "Julee-Regular.ttf"

  # No zap stanza required
end