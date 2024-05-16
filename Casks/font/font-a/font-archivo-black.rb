cask "font-archivo-black" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflarchivoblackArchivoBlack-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Archivo Black"
  homepage "https:fonts.google.comspecimenArchivo+Black"

  font "ArchivoBlack-Regular.ttf"

  # No zap stanza required
end