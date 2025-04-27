cask "font-kanchenjunga" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflkanchenjunga"
  name "Kanchenjunga"
  homepage "https:fonts.google.comspecimenKanchenjunga"

  font "Kanchenjunga-Bold.ttf"
  font "Kanchenjunga-Medium.ttf"
  font "Kanchenjunga-Regular.ttf"
  font "Kanchenjunga-SemiBold.ttf"

  # No zap stanza required
end