cask "font-kosugi-maru" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapachekosugimaruKosugiMaru-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Kosugi Maru"
  desc "Available as kosugi"
  homepage "https:fonts.google.comspecimenKosugi+Maru"

  font "KosugiMaru-Regular.ttf"

  # No zap stanza required
end