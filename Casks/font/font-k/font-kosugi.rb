cask "font-kosugi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapachekosugiKosugi-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Kosugi"
  homepage "https:fonts.google.comspecimenKosugi"

  font "Kosugi-Regular.ttf"

  # No zap stanza required
end