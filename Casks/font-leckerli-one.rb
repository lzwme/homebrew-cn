cask "font-leckerli-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflleckerlioneLeckerliOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Leckerli One"
  homepage "https:fonts.google.comspecimenLeckerli+One"

  font "LeckerliOne-Regular.ttf"

  # No zap stanza required
end