cask "font-libre-caslon-text" do
  version :latest
  sha256 :no_check

  url "https:github.comimpallariLibre-Caslon-Textarchiverefsheadsmaster.tar.gz"
  name "Libre Caslon Text"
  homepage "https:github.comimpallariLibre-Caslon-Text"

  font "Libre-Caslon-Text-masterfontsOTFLibreCaslonText-Bold.otf"
  font "Libre-Caslon-Text-masterfontsOTFLibreCaslonText-Italic.otf"
  font "Libre-Caslon-Text-masterfontsOTFLibreCaslonText-Regular.otf"

  # No zap stanza required
end