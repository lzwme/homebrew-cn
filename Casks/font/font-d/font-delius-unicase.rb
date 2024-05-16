cask "font-delius-unicase" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofldeliusunicase"
  name "Delius Unicase"
  homepage "https:fonts.google.comspecimenDelius+Unicase"

  font "DeliusUnicase-Bold.ttf"
  font "DeliusUnicase-Regular.ttf"

  # No zap stanza required
end