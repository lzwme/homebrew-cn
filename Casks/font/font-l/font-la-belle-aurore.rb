cask "font-la-belle-aurore" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllabelleauroreLaBelleAurore.ttf",
      verified: "github.comgooglefonts"
  name "La Belle Aurore"
  homepage "https:fonts.google.comspecimenLa+Belle+Aurore"

  font "LaBelleAurore.ttf"

  # No zap stanza required
end