cask "font-nanum-gothic-coding" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflnanumgothiccoding"
  name "Nanum Gothic Coding"
  homepage "https:fonts.google.comspecimenNanum+Gothic+Coding"

  font "NanumGothicCoding-Bold.ttf"
  font "NanumGothicCoding-Regular.ttf"

  # No zap stanza required
end