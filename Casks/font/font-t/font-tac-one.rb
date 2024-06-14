cask "font-tac-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofltaconeTacOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Tac One"
  homepage "https:fonts.google.comspecimenTac+One"

  font "TacOne-Regular.ttf"

  # No zap stanza required
end