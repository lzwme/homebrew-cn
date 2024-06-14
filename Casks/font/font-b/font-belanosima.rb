cask "font-belanosima" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbelanosima"
  name "Belanosima"
  homepage "https:fonts.google.comspecimenBelanosima"

  font "Belanosima-Bold.ttf"
  font "Belanosima-Regular.ttf"
  font "Belanosima-SemiBold.ttf"

  # No zap stanza required
end