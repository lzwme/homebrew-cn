cask "font-narnoor" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflnarnoor"
  name "Narnoor"
  homepage "https:fonts.google.comspecimenNarnoor"

  font "Narnoor-Bold.ttf"
  font "Narnoor-ExtraBold.ttf"
  font "Narnoor-Medium.ttf"
  font "Narnoor-Regular.ttf"
  font "Narnoor-SemiBold.ttf"

  # No zap stanza required
end