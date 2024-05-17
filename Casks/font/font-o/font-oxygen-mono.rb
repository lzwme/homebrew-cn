cask "font-oxygen-mono" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofloxygenmonoOxygenMono-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Oxygen Mono"
  homepage "https:fonts.google.comspecimenOxygen+Mono"

  font "OxygenMono-Regular.ttf"

  # No zap stanza required
end