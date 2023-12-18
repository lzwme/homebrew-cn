cask "font-nanum-gothic" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflnanumgothic"
  name "Nanum Gothic"
  homepage "https:fonts.google.comspecimenNanum+Gothic"

  font "NanumGothic-Bold.ttf"
  font "NanumGothic-ExtraBold.ttf"
  font "NanumGothic-Regular.ttf"

  # No zap stanza required
end