cask "font-montserrat-subrayada" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflmontserratsubrayada"
  name "Montserrat Subrayada"
  homepage "https:fonts.google.comspecimenMontserrat+Subrayada"

  font "MontserratSubrayada-Bold.ttf"
  font "MontserratSubrayada-Regular.ttf"

  # No zap stanza required
end