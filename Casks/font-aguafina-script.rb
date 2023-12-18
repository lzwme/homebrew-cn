cask "font-aguafina-script" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflaguafinascriptAguafinaScript-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Aguafina Script"
  homepage "https:fonts.google.comspecimenAguafina+Script"

  font "AguafinaScript-Regular.ttf"

  # No zap stanza required
end