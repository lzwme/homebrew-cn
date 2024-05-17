cask "font-prociono" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflprocionoProciono-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Prociono"
  homepage "https:fonts.google.comspecimenProciono"

  font "Prociono-Regular.ttf"

  # No zap stanza required
end